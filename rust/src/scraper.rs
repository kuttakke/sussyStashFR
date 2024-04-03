use crate::api::streamer_model::{Streamer, StreamerType, StreamerVideo};
use crate::fetch::fetch_raw_with_retry;
use crate::static_args::StaticArgs;
use anyhow::Result;
use scraper::{selectable::Selectable, Html};

pub async fn get_streamers(type_: StreamerType) -> Result<Vec<Streamer>> {
    let static_args = StaticArgs::instance();
    let html = fetch_raw_with_retry(|| {
        static_args
            .client
            .get(format!("https://stash.sussy.moe/{}", type_.to_string()))
    })
    .await?
    .text()
    .await?;
    // println!("{}", &html);

    let document = Html::parse_fragment(&html);
    // let selector = Selector::parse("main div a").unwrap();
    let mut streamers = Vec::new();
    for a in document.select(&static_args.main_div_a) {
        let url = a.value().attr("href").unwrap();
        let image_src = a
            // .select(&Selector::parse("img").unwrap())
            .select(&static_args.img)
            .next()
            .unwrap()
            .value()
            .attr("src")
            .unwrap();
        let name = a
            // .select(&Selector::parse("p:nth-child(2)").unwrap())
            .select(&static_args.p_child2)
            .next()
            .unwrap()
            .text()
            .collect::<String>();
        let name_en = a
            // .select(&Selector::parse("p:nth-child(3)").unwrap())
            .select(&static_args.p_child3)
            .next()
            .map_or_else(|| "".to_string(), |node| node.text().collect::<String>());
        // debug_print!("{name} {name_en} {image_src}");
        streamers.push(Streamer {
            name,
            type_,
            icon: format!("https://stash.sussy.moe{}", image_src),
            name_en,
            url: format!("https://stash.sussy.moe{}", url),
        });
    }
    // debug_print!("return streamers");
    Ok(streamers)
}

pub async fn get_streamer_videos(url: &str) -> Result<Vec<StreamerVideo>> {
    let static_args = StaticArgs::instance();
    let html = fetch_raw_with_retry(|| static_args.client.get(url))
        .await?
        .text()
        .await?;
    // println!("{}", &html);
    let document = Html::parse_fragment(&html);
    // let selector = Selector::parse("main div a").unwrap();

    let mut videos = Vec::new();
    for a in document.select(&static_args.main_div_a) {
        let url = a.value().attr("href").unwrap();
        let cover = a
            // .select(&Selector::parse("img").unwrap())
            .select(&static_args.img)
            .next()
            .unwrap()
            .value()
            .attr("src")
            .unwrap();
        let title = a
            // .select(&Selector::parse("p:nth-child(2)").unwrap())
            .select(&static_args.p_child2)
            .next()
            .unwrap()
            .text()
            .collect::<String>();
        let uploaded = a
            // .select(&Selector::parse("p:nth-child(3)").unwrap())
            .select(&static_args.p_child3)
            .next()
            .unwrap()
            .text()
            .collect::<String>()
            .replace("Uploaded ", "");
        videos.push(StreamerVideo {
            url: format!("https://stash.sussy.moe{}", url),
            title,
            uploaded,
            cover: format!("https://stash.sussy.moe{}", cover),
            src: format!("https://stash-data.sussy.moe{}", url),
        });
    }
    Ok(videos)
}

pub async fn get_more_videos(url: &str) -> Result<Vec<StreamerVideo>> {
    let static_args = StaticArgs::instance();
    let html = fetch_raw_with_retry(|| static_args.client.get(url))
        .await?
        .text()
        .await?;
    let document = Html::parse_fragment(&html);
    let mut videos = Vec::new();
    for a in document.select(&static_args.main_more) {
        let url = a.value().attr("href").unwrap();
        println!("url: {}", url);
        let cover = a
            // .select(&Selector::parse("img").unwrap())
            .select(&static_args.img)
            .next()
            .unwrap()
            .value()
            .attr("src")
            .unwrap();
        let title = a
            // .select(&Selector::parse("p:nth-child(2)").unwrap())
            .select(&static_args.p_child2)
            .next()
            .unwrap()
            .text()
            .collect::<String>();
        let uploaded = a
            // .select(&Selector::parse("p:nth-child(3)").unwrap())
            .select(&static_args.p_child3)
            .next()
            .unwrap()
            .text()
            .collect::<String>()
            .replace("Uploaded ", "");
        videos.push(StreamerVideo {
            url: format!("https://stash.sussy.moe{}", url),
            title,
            uploaded,
            cover: format!("https://stash.sussy.moe{}", cover),
            src: format!("https://stash-data.sussy.moe{}", url),
        });
    }
    Ok(videos)
}

#[cfg(test)]
mod tests {
    use super::*;
    #[tokio::test]
    async fn test_get_more() {
        let res = get_more_videos("https://stash.sussy.moe/karaoke/moona/20230521%20%E3%80%90MoonUtau%E3%80%91Chill%20karaoke%20night%E3%80%90Unarchive%E3%80%91%20%5BMoona%20Hoshinova%20hololive-ID%5D%20(sXA3o8dp4q0).mp4").await;
        match res {
            Err(e) => {
                println!("{:?}", e);
            }
            Ok(v) => {
                println!("{:?}", v.len());
            }
        }
    }
}
