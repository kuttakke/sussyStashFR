use anyhow::{Result as AnyResult, anyhow};


pub async fn fetch_raw_with_retry<F>(builder: F) -> AnyResult<reqwest::Response>
where
    F: Fn() -> reqwest::RequestBuilder,
{
    let mut retry_count = 0;

    loop {
        match builder().send().await {
            Ok(response) if response.status().is_success() => {
                return Ok(response);
            }
            Ok(_) => {
                retry_count += 1;
                if retry_count >= 3 {
                    return Err(anyhow!("Max retries reached".to_string()));
                    
                }
            }
            Err(e) => {
                retry_count += 1;
                if retry_count >= 3 {
                    return Err(anyhow!(e));
                }
            }
        }
    }
}
