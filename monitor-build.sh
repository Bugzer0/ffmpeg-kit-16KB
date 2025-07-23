#!/bin/bash

# Script để monitor build progress
# Sử dụng: ./monitor-build.sh

echo "📊 FFmpeg-Kit Build Monitor"
echo "=========================="
echo ""

# Kiểm tra nếu build đang chạy
if pgrep -f "android.sh" > /dev/null; then
    echo "✅ Build đang chạy..."
else
    echo "⚠️  Không phát hiện build process"
    echo "   Có thể build đã hoàn thành hoặc bị dừng"
fi

echo ""
echo "📈 Tiến trình build (theo build.log):"
echo ""

# Hiển thị libraries đã build thành công
echo "🟢 Libraries đã build xong:"
grep -E ": ok$" build.log | tail -10 | sed 's/^/   /'

echo ""
echo "🔄 Library đang build:"
tail -20 build.log | grep -E "INFO: Building|DEBUG: Checking" | tail -1 | sed 's/^/   /'

echo ""
echo "📏 Kích thước build.log: $(ls -lh build.log | awk '{print $5}')"
echo "📅 Thời gian bắt đầu: $(head -5 build.log | grep "INFO: Building ffmpeg-kit" | head -1)"

echo ""
echo "🔍 5 dòng cuối của build.log:"
echo "------------------------"
tail -5 build.log

echo ""
echo "💡 Để xem realtime log:"
echo "   tail -f build.log"
echo ""
echo "🚨 Nếu có lỗi:"
echo "   grep -i error build.log | tail -5" 