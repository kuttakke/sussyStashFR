#[derive(Clone, Copy)]
pub enum StreamerType {
    FC2,
    KARAOKE,
    MISC,
}

impl StreamerType {
    #[flutter_rust_bridge::frb(sync)]
    pub fn to_string(&self) -> String {
        match self {
            &Self::FC2 => "fc2".to_string(),
            &Self::KARAOKE => "karaoke".to_string(),
            &Self::MISC => "misc".to_string(),
        }
    }
}

pub struct Streamer {
    pub type_: StreamerType,
    pub name: String,
    pub name_en: String,
    pub icon: String,
    pub url: String,
}

pub struct StreamersResponse {
    pub ok: bool,
    pub msg: String,
    pub streamers: Vec<Streamer>,
}

pub struct StreamerVideo {
    pub url: String,
    pub title: String,
    pub uploaded: String,
    pub cover: String,
    pub src: String,
}

pub struct StreamerVideoResponse {
    pub ok: bool,
    pub msg: String,
    pub videos: Vec<StreamerVideo>,
}

pub struct StreamerVideoDetail {
    pub url: String,
    pub title: String,
    pub uploaded: String,
    pub cover: String,
    pub src: String,
    pub size: String,

    pub more_videos: Vec<StreamerVideo>,
}

pub struct StreamerVideoDetailResponse {
    pub ok: bool,
    pub msg: String,
    pub video: StreamerVideoDetail,
}
