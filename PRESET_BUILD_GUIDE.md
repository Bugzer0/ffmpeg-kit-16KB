# Hướng dẫn Build FFmpeg-Kit theo Preset Mobile-FFmpeg

Script `build-presets.sh` này giúp bạn build FFmpeg-Kit với cấu hình tương tự các preset của Mobile-FFmpeg-master, giúp giảm kích thước thư viện và chỉ bao gồm những tính năng cần thiết.

## 📋 Danh sách Preset

### Non-GPL Presets
| Preset | Mô tả | Libraries bao gồm |
|--------|-------|-------------------|
| `min` | Minimal build | android-zlib, android-media-codec |
| `https` | HTTPS support | min + gmp, gnutls |
| `audio` | Audio processing | min + lame, libilbc, libvorbis, opencore-amr, opus, shine, soxr, speex, twolame, vo-amrwbenc |
| `video` | Video processing | min + fontconfig, freetype, fribidi, kvazaar, libaom, libass, libiconv, libtheora, libvpx, snappy, libwebp |
| `full` | Full features | min + https + audio + video + libxml2 |

### GPL Presets (Yêu cầu --enable-gpl)
| Preset | Mô tả | Libraries bao gồm |
|--------|-------|-------------------|
| `min-gpl` | Minimal với GPL | min + libvidstab, x264, x265, xvidcore |
| `https-gpl` | HTTPS với GPL | https + GPL libraries |
| `full-gpl` | Full với GPL | full + GPL libraries |

## ⚠️ Khác biệt với Mobile-FFmpeg

**Libraries không có trong FFmpeg-Kit:**
- `wavpack` - Không được support, đã loại bỏ khỏi preset audio

**Libraries mới trong FFmpeg-Kit (không có trong preset này):**
- `chromaprint`, `dav1d`, `openh264`, `rubberband`, `tesseract`, `zimg`

## 🚀 Cách sử dụng

### 1. Chuẩn bị môi trường
```bash
# Đảm bảo đã thiết lập ANDROID_SDK_ROOT và ANDROID_NDK_ROOT
export ANDROID_SDK_ROOT=/path/to/android/sdk
export ANDROID_NDK_ROOT=/path/to/android/ndk

# Cấp quyền thực thi cho script
chmod +x build-presets.sh
```

### 2. Build preset cụ thể
```bash
# Build preset minimal (chỉ basic features)
./build-presets.sh min

# Build preset audio (cho ứng dụng audio - không bao gồm wavpack)
./build-presets.sh audio

# Build preset video (cho ứng dụng video)
./build-presets.sh video

# Build preset full (đầy đủ features non-GPL)
./build-presets.sh full

# Build preset full-gpl (đầy đủ features bao gồm GPL)
./build-presets.sh full-gpl
```

### 3. Xem trợ giúp
```bash
./build-presets.sh --help
```

## 📊 So sánh kích thước (ước tính)

| Preset | Kích thước AAR | Use case |
|--------|----------------|----------|
| min | ~8-12 MB | Ứng dụng cơ bản, chỉ cần decode/encode basic |
| https | ~12-16 MB | Ứng dụng cần download/stream qua HTTPS |
| audio | ~15-20 MB | Ứng dụng xử lý audio (music player, audio editor) - nhỏ hơn do bỏ wavpack |
| video | ~20-35 MB | Ứng dụng xử lý video (video player, converter) |
| full | ~30-45 MB | Ứng dụng đa năng - nhỏ hơn do bỏ wavpack |
| full-gpl | ~35-55 MB | Ứng dụng đa năng với GPL codecs |

## 🔧 Tuỳ chỉnh

Nếu bạn muốn tuỳ chỉnh preset, bạn có thể:

### 1. Thêm libraries mới vào preset
```bash
# Ví dụ: Thêm chromaprint vào preset audio
AUDIO_LIBS="--enable-lame --enable-chromaprint --enable-libilbc ..."

# Thêm dav1d vào preset video
VIDEO_LIBS="--enable-fontconfig --enable-dav1d --enable-freetype ..."
```

### 2. Tạo preset tương thích hoàn toàn với mobile-ffmpeg
Nếu bạn cần wavpack (từ external library), hãy build riêng:
```bash
# Build với wavpack từ external source (nếu có)
./android.sh --enable-android-zlib --enable-lame --enable-opus --enable-custom-library-wavpack=/path/to/wavpack
```

### 3. Build trực tiếp với android.sh
```bash
# Build custom với libraries cụ thể
./android.sh --enable-android-zlib --enable-lame --enable-x264 --enable-gpl
```

## 📁 Output

Sau khi build thành công:
- File AAR sẽ được tạo trong thư mục `prebuilt/android-aar-{api}/ffmpeg-kit/`
- File log chi tiết trong `build.log`

## ⚠️ Lưu ý quan trọng

1. **GPL License**: Nếu bạn sử dụng preset có `-gpl`, toàn bộ library sẽ được license dưới GPL v3.0
2. **Dependency**: Một số libraries có dependency lẫn nhau, script đã xử lý tự động
3. **Compatibility**: Preset này tương thích ~95% với mobile-ffmpeg (chỉ thiếu wavpack)
4. **Build time**: 
   - `min`: ~15-30 phút
   - `full`: ~1.5-3 giờ (nhanh hơn do bỏ wavpack)
   - `full-gpl`: ~2-4 giờ
5. **Disk space**: Cần ít nhất 8-15GB trống cho full build

## 🐛 Troubleshooting

### Build bị lỗi
```bash
# Xem chi tiết lỗi
tail -f build.log

# Clean và build lại
./clean.sh
./build-presets.sh [preset]
```

### Thiếu dependencies
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install build-essential git autotools-dev automake libtool pkg-config

# macOS
brew install autotools automake libtool pkg-config
```

### NDK/SDK không được nhận dạng
```bash
# Kiểm tra đường dẫn
echo $ANDROID_SDK_ROOT
echo $ANDROID_NDK_ROOT

# Set lại nếu cần
export ANDROID_SDK_ROOT=/Users/yourname/Library/Android/sdk
export ANDROID_NDK_ROOT=/Users/yourname/Library/Android/sdk/ndk/21.4.7075529
```

### Muốn sử dụng wavpack
```bash
# Option 1: Build manual với libraries tương tự
./android.sh --enable-android-zlib --enable-lame --enable-opus [other libs]

# Option 2: Tìm alternative library cho wavpack functionality
# - soxr: audio resampling
# - opus: high-quality audio codec
```

## 📞 Hỗ trợ

Nếu gặp vấn đề:
1. Kiểm tra `build.log` để xem lỗi chi tiết
2. Đảm bảo Android SDK/NDK được cài đặt đúng
3. Kiểm tra disk space và permissions
4. Thử build với preset đơn giản hơn trước (vd: `min`)
5. Tham khảo `LIBRARY_COMPARISON.md` để hiểu sự khác biệt

---

**Ghi chú**: Script này được thiết kế dựa trên cấu trúc preset của Mobile-FFmpeg để giảm complexity và kích thước của FFmpeg-Kit build. Mặc dù không 100% tương thích do thiếu wavpack, nhưng vẫn đảm bảo chức năng chính cho hầu hết use cases. 