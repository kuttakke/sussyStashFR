use crate::api::streamer_model::{
    StreamerType, StreamerVideoResponse, StreamersResponse,
};

use crate::scraper::{get_streamer_videos, get_streamers, get_more_videos as get_more_videos_};

pub async fn get_videos(url: String) -> StreamerVideoResponse {
    let videos = get_streamer_videos(&url).await;

    match videos {
        Err(e) => {
            // debug_print!("Error: {}", e);
            StreamerVideoResponse {
                ok: false,
                msg: e.to_string(),
                videos: vec![],
            }
        }
        Ok(videos) => {
            if videos.len() == 0 {
                StreamerVideoResponse {
                    ok: false,
                    msg: "获取错误".to_string(),
                    videos: vec![],
                }
            } else {
                StreamerVideoResponse {
                    ok: true,
                    msg: "获取成功".to_string(),
                    videos,
                }
            }
        }
    }
}

pub async fn get_category(type_: StreamerType) -> StreamersResponse {
    let streamers = get_streamers(type_).await;

    match streamers {
        Err(e) => StreamersResponse {
            ok: false,
            msg: format!("Error: {}", e),
            streamers: vec![],
        },
        Ok(streamers) => {
            if streamers.len() == 0 {
                StreamersResponse {
                    ok: false,
                    msg: "获取错误".to_string(),
                    streamers: Vec::new(),
                }
            } else {
                StreamersResponse {
                    ok: true,
                    msg: "获取成功".to_string(),
                    streamers,
                }
            }
        }
    }
}

pub async fn get_more_videos(url: String) -> StreamerVideoResponse {
    let videos = get_more_videos_(&url).await;

    match videos {
        Err(e) => {
            // debug_print!("Error: {}", e);
            StreamerVideoResponse {
                ok: false,
                msg: e.to_string(),
                videos: vec![],
            }
        }
        Ok(videos) => {
            if videos.len() == 0 {
                StreamerVideoResponse {
                    ok: false,
                    msg: "获取错误".to_string(),
                    videos: vec![],
                }
            } else {
                StreamerVideoResponse {
                    ok: true,
                    msg: "获取成功".to_string(),
                    videos,
                }
            }
        }
    }
}