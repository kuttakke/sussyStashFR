// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.29.

// Section: imports

use super::*;
use flutter_rust_bridge::for_generated::byteorder::{NativeEndian, ReadBytesExt, WriteBytesExt};
use flutter_rust_bridge::for_generated::transform_result_dco;
use flutter_rust_bridge::for_generated::wasm_bindgen;
use flutter_rust_bridge::for_generated::wasm_bindgen::prelude::*;
use flutter_rust_bridge::{Handler, IntoIntoDart};

// Section: boilerplate

flutter_rust_bridge::frb_generated_boilerplate_web!();

// Section: dart2rust

impl CstDecode<String> for String {
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> String {
        self
    }
}
impl CstDecode<Vec<u8>> for Box<[u8]> {
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> Vec<u8> {
        self.into_vec()
    }
}
impl CstDecode<Vec<crate::api::streamer_model::Streamer>>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> Vec<crate::api::streamer_model::Streamer> {
        self.dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap()
            .iter()
            .map(CstDecode::cst_decode)
            .collect()
    }
}
impl CstDecode<Vec<crate::api::streamer_model::StreamerVideo>>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> Vec<crate::api::streamer_model::StreamerVideo> {
        self.dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap()
            .iter()
            .map(CstDecode::cst_decode)
            .collect()
    }
}
impl CstDecode<crate::api::streamer_model::Streamer>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> crate::api::streamer_model::Streamer {
        let self_ = self
            .dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap();
        assert_eq!(
            self_.length(),
            5,
            "Expected 5 elements, got {}",
            self_.length()
        );
        crate::api::streamer_model::Streamer {
            type_: self_.get(0).cst_decode(),
            name: self_.get(1).cst_decode(),
            name_en: self_.get(2).cst_decode(),
            icon: self_.get(3).cst_decode(),
            url: self_.get(4).cst_decode(),
        }
    }
}
impl CstDecode<crate::api::streamer_model::StreamerVideo>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> crate::api::streamer_model::StreamerVideo {
        let self_ = self
            .dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap();
        assert_eq!(
            self_.length(),
            5,
            "Expected 5 elements, got {}",
            self_.length()
        );
        crate::api::streamer_model::StreamerVideo {
            url: self_.get(0).cst_decode(),
            title: self_.get(1).cst_decode(),
            uploaded: self_.get(2).cst_decode(),
            cover: self_.get(3).cst_decode(),
            src: self_.get(4).cst_decode(),
        }
    }
}
impl CstDecode<crate::api::streamer_model::StreamerVideoResponse>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> crate::api::streamer_model::StreamerVideoResponse {
        let self_ = self
            .dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap();
        assert_eq!(
            self_.length(),
            3,
            "Expected 3 elements, got {}",
            self_.length()
        );
        crate::api::streamer_model::StreamerVideoResponse {
            ok: self_.get(0).cst_decode(),
            msg: self_.get(1).cst_decode(),
            videos: self_.get(2).cst_decode(),
        }
    }
}
impl CstDecode<crate::api::streamer_model::StreamersResponse>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> crate::api::streamer_model::StreamersResponse {
        let self_ = self
            .dyn_into::<flutter_rust_bridge::for_generated::js_sys::Array>()
            .unwrap();
        assert_eq!(
            self_.length(),
            3,
            "Expected 3 elements, got {}",
            self_.length()
        );
        crate::api::streamer_model::StreamersResponse {
            ok: self_.get(0).cst_decode(),
            msg: self_.get(1).cst_decode(),
            streamers: self_.get(2).cst_decode(),
        }
    }
}
impl CstDecode<String> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> String {
        self.as_string().expect("non-UTF-8 string, or not a string")
    }
}
impl CstDecode<bool> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> bool {
        self.is_truthy()
    }
}
impl CstDecode<i32> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> i32 {
        self.unchecked_into_f64() as _
    }
}
impl CstDecode<Vec<u8>> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> Vec<u8> {
        self.unchecked_into::<flutter_rust_bridge::for_generated::js_sys::Uint8Array>()
            .to_vec()
            .into()
    }
}
impl CstDecode<crate::api::streamer_model::StreamerType>
    for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue
{
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> crate::api::streamer_model::StreamerType {
        (self.unchecked_into_f64() as i32).cst_decode()
    }
}
impl CstDecode<u8> for flutter_rust_bridge::for_generated::wasm_bindgen::JsValue {
    // Codec=Cst (C-struct based), see doc to use other codecs
    fn cst_decode(self) -> u8 {
        self.unchecked_into_f64() as _
    }
}

#[wasm_bindgen]
pub fn wire_greet(name: String) -> flutter_rust_bridge::for_generated::WireSyncRust2DartDco {
    wire_greet_impl(name)
}

#[wasm_bindgen]
pub fn wire_init_app(port_: flutter_rust_bridge::for_generated::MessagePort) {
    wire_init_app_impl(port_)
}

#[wasm_bindgen]
pub fn wire_get_category(port_: flutter_rust_bridge::for_generated::MessagePort, type_: i32) {
    wire_get_category_impl(port_, type_)
}

#[wasm_bindgen]
pub fn wire_get_more_videos(port_: flutter_rust_bridge::for_generated::MessagePort, url: String) {
    wire_get_more_videos_impl(port_, url)
}

#[wasm_bindgen]
pub fn wire_get_videos(port_: flutter_rust_bridge::for_generated::MessagePort, url: String) {
    wire_get_videos_impl(port_, url)
}

#[wasm_bindgen]
pub fn wire_StreamerType_to_string(
    that: i32,
) -> flutter_rust_bridge::for_generated::WireSyncRust2DartDco {
    wire_StreamerType_to_string_impl(that)
}
