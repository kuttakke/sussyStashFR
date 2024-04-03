use reqwest::Client;
use scraper::Selector;
use std::sync::OnceLock;

pub struct StaticArgs {
    pub main_div_a: Selector,
    pub main_more: Selector,
    pub img: Selector,
    pub p_child2: Selector,
    pub p_child3: Selector,
    pub client: Client,
}

impl StaticArgs {
    pub fn instance() -> &'static Self {
        static INSTANCE: OnceLock<StaticArgs> = OnceLock::new();
        INSTANCE.get_or_init(|| Self {
            main_div_a: Selector::parse("main div a").unwrap(),
            main_more: Selector::parse("main div div:nth-child(4) div:nth-child(2) a").unwrap(),
            img: Selector::parse("img").unwrap(),
            p_child2: Selector::parse("p:nth-child(2)").unwrap(),
            p_child3: Selector::parse("p:nth-child(3)").unwrap(),
            client: Client::new(),
        })
    }
}