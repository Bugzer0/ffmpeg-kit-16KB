# So sánh Libraries: Mobile-FFmpeg vs FFmpeg-Kit

Bảng so sánh này giúp bạn hiểu sự khác biệt về libraries giữa Mobile-FFmpeg-master và FFmpeg-Kit-16KB.

## 📋 Libraries có trong cả hai

| Library | Mobile-FFmpeg | FFmpeg-Kit | Mô tả |
|---------|---------------|------------|--------|
| **Audio Libraries** |
| lame | ✅ | ✅ | MP3 encoder |
| libilbc | ✅ | ✅ | iLBC audio codec |
| libvorbis | ✅ | ✅ | Vorbis audio codec |
| opencore-amr | ✅ | ✅ | AMR audio codec |
| opus | ✅ | ✅ | Opus audio codec |
| shine | ✅ | ✅ | MP3 encoder (fixed-point) |
| soxr | ✅ | ✅ | Audio resampling |
| speex | ✅ | ✅ | Speex audio codec |
| twolame | ✅ | ✅ | MP2 encoder |
| vo-amrwbenc | ✅ | ✅ | AMR-WB encoder |
| **Video Libraries** |
| fontconfig | ✅ | ✅ | Font configuration |
| freetype | ✅ | ✅ | Font rendering |
| fribidi | ✅ | ✅ | Unicode text layout |
| kvazaar | ✅ | ✅ | HEVC encoder |
| libaom | ✅ | ✅ | AV1 codec |
| libass | ✅ | ✅ | Subtitle rendering |
| libiconv | ✅ | ✅ | Character encoding |
| libtheora | ✅ | ✅ | Theora video codec |
| libvpx | ✅ | ✅ | VP8/VP9 codec |
| libwebp | ✅ | ✅ | WebP image format |
| snappy | ✅ | ✅ | Compression library |
| **Security Libraries** |
| gmp | ✅ | ✅ | Multiple precision arithmetic |
| gnutls | ✅ | ✅ | TLS/SSL library |
| **Other Libraries** |
| libxml2 | ✅ | ✅ | XML parsing |
| **GPL Libraries** |
| libvidstab | ✅ | ✅ | Video stabilization |
| x264 | ✅ | ✅ | H.264 encoder |
| x265 | ✅ | ✅ | HEVC encoder |
| xvidcore | ✅ | ✅ | MPEG-4 encoder |

## 📋 Libraries chỉ có trong FFmpeg-Kit

| Library | FFmpeg-Kit | Mô tả |
|---------|------------|--------|
| **Media Processing** |
| chromaprint | ✅ | Audio fingerprinting |
| dav1d | ✅ | AV1 decoder |
| openh264 | ✅ | H.264 codec (Cisco) |
| **System Libraries** |
| cpu-features | ✅ | Android CPU detection |
| **Additional Libraries** |
| rubberband | ✅ | Audio time-stretching |
| tesseract | ✅ | OCR (Optical Character Recognition) |
| zimg | ✅ | Image scaling |

## ❌ Libraries chỉ có trong Mobile-FFmpeg

| Library | Mobile-FFmpeg | FFmpeg-Kit | Lý do |
|---------|---------------|------------|--------|
| **Audio Libraries** |
| wavpack | ✅ | ❌ | Không được support trong FFmpeg-Kit |

## 📋 Libraries không có trong Mobile-FFmpeg presets

Mobile-FFmpeg-master có các thư viện sau trong source code nhưng không được enable trong các preset:

| Library | Có trong src | Lý do không enable |
|---------|--------------|------------------|
| chromaprint | ✅ | Removed từ v4.2+ |
| sdl | ✅ | Removed từ v4.2+ |
| tesseract | ✅ | Removed từ v4.2+ |
| giflib | ✅ | Dependency library |
| jpeg | ✅ | Dependency library |
| libogg | ✅ | Dependency library |
| libpng | ✅ | Dependency library |
| libuuid | ✅ | Dependency library |
| nettle | ✅ | Dependency library |
| expat | ✅ | Dependency library |
| tiff | ✅ | Dependency library |

## 🎯 Khuyến nghị Preset cho Use Cases

### Ứng dụng Audio (Music Player, Audio Editor)
```bash
./build-presets.sh audio
```
**Libraries**: lame, libilbc, libvorbis, opencore-amr, opus, shine, soxr, speex, twolame, vo-amrwbenc
**Lưu ý**: Không bao gồm wavpack. Có thể sử dụng opus hoặc soxr thay thế

### Ứng dụng Video (Video Player, Converter) 
```bash
./build-presets.sh video
```
**Libraries**: fontconfig, freetype, fribidi, kvazaar, libaom, libass, libiconv, libtheora, libvpx, snappy, libwebp

### Ứng dụng cần HTTPS/Streaming
```bash
./build-presets.sh https
```
**Libraries**: gmp, gnutls

### Ứng dụng đa năng
```bash
./build-presets.sh full
```
**Libraries**: Tất cả non-GPL libraries (trừ wavpack)

### Ứng dụng cần encoding chất lượng cao
```bash
./build-presets.sh full-gpl
```
**Libraries**: Tất cả libraries bao gồm x264, x265, libvidstab (trừ wavpack)

## 🔧 Tuỳ chỉnh nâng cao

Nếu bạn cần thêm libraries không có trong preset:

### Thêm Chromaprint (Audio fingerprinting)
```bash
# Sửa AUDIO_LIBS trong build-presets.sh
AUDIO_LIBS="--enable-lame --enable-chromaprint --enable-libilbc ..."
```

### Thêm DAV1D (AV1 decoder hiệu năng cao)
```bash
# Sửa VIDEO_LIBS trong build-presets.sh  
VIDEO_LIBS="--enable-fontconfig --enable-dav1d --enable-freetype ..."
```

### Thêm OpenH264 (H.264 codec từ Cisco)
```bash
# Sửa VIDEO_LIBS trong build-presets.sh
VIDEO_LIBS="--enable-fontconfig --enable-openh264 --enable-freetype ..."
```

### Thay thế Wavpack
Nếu bạn cần chức năng tương tự wavpack:
```bash
# Option 1: Sử dụng OPUS (high-quality audio)
AUDIO_LIBS="... --enable-opus ..."

# Option 2: Sử dụng SOXR (audio resampling)  
AUDIO_LIBS="... --enable-soxr ..."

# Option 3: Build external wavpack library (advanced)
./android.sh --enable-custom-library-wavpack=/path/to/wavpack-build
```

## ⚖️ License Considerations

| License Type | Libraries | Ràng buộc |
|-------------|-----------|-----------|
| **LGPL** | Hầu hết libraries | Có thể dùng trong app thương mại |
| **GPL** | x264, x265, xvidcore, libvidstab | App phải GPL hoặc có license riêng |
| **BSD/MIT** | chromaprint, dav1d, openh264 | Tự do sử dụng |

## 📊 Kích thước ước tính khi thêm libraries

| Library | Kích thước thêm | Impact |
|---------|----------------|--------|
| chromaprint | +2-3 MB | Audio fingerprinting |
| dav1d | +1-2 MB | AV1 decoding performance |
| openh264 | +1-2 MB | H.264 Cisco implementation |
| tesseract | +15-20 MB | OCR functionality |
| rubberband | +2-3 MB | Audio time-stretching |

## 🎯 Kết luận

- **Mobile-FFmpeg presets** đã được tối ưu cho kích thước và performance
- **FFmpeg-Kit** cung cấp nhiều options hơn nhưng thiếu wavpack
- **Script build-presets.sh** giúp bạn có được cấu hình ~95% tương tự Mobile-FFmpeg
- **Wavpack alternative**: Sử dụng opus (chất lượng cao) hoặc soxr (resampling)
- **Chọn preset phù hợp** với use case để tối ưu kích thước

## 📈 Compatibility Score

| Preset | Compatibility với Mobile-FFmpeg | Lý do |
|--------|--------------------------------|--------|
| min | 100% | Hoàn toàn tương thích |
| https | 100% | Hoàn toàn tương thích |
| audio | 95% | Thiếu wavpack |
| video | 100% | Hoàn toàn tương thích |
| full | 98% | Thiếu wavpack |
| full-gpl | 98% | Thiếu wavpack | 