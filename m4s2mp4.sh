#!/bin/bash

cat << "EOF"
  __  __  _  _   ____  ___   __  __  ____  _  _   
 |  \/  || || | / ___||__ \ |  \/  ||  _ \| || |  
 | |\/| || || |_\___ \  / / | |\/| || |_) | || |_ 
 | |  | ||__   _|___) |/ /_ | |  | ||  __/|__   _|
 |_|  |_|   |_| |____/|____||_|  |_||_|      |_|  
                                                  
EOF
echo "================================================="
echo "            M4S to MP4 Converter.                "
echo "================================================="

# 检测 ffmpeg：优先使用当前目录，其次检测系统全局变量
if [ -x "$PWD/ffmpeg" ]; then
    FFMPEG_CMD="$PWD/ffmpeg"
elif command -v ffmpeg >/dev/null 2>&1; then
    FFMPEG_CMD="ffmpeg"
else
    echo "❌ 错误：未在当前目录或全局环境变量中找到 ffmpeg"
    exit 1
fi

# 获取目录列表
dirs=()
for d in */; do
    if [ -d "$d" ]; then
        dirs+=("${d%/}")
    fi
done

if [ ${#dirs[@]} -eq 0 ]; then
    echo "❌ 错误：未找到任何文件夹"
    exit 1
fi

# 打印菜单
echo "📂 扫描到以下文件夹："
for i in "${!dirs[@]}"; do
    printf "  [%d] %s\n" $((i+1)) "${dirs[$i]}"
done
echo "  [all] 一键处理所有文件夹"
echo "================================================="

read -p "👉 请输入选项 (1-${#dirs[@]} 或 all): " choice

# 核心处理模块
process_dir() {
    local target_dir="$1"
    echo -e "\n-------------------------------------------------"
    echo "🚀 处理文件夹: [$target_dir]"

    local m4s_files=("$target_dir"/*.m4s)

    # 校验 m4s 文件数量
    if [ "${#m4s_files[@]}" -ne 2 ] || [ ! -e "${m4s_files[0]}" ]; then
        echo "⚠️  跳过：未在该目录找到 2 个 .m4s 文件"
        return
    fi

    local file1="${m4s_files[0]}"
    local file2="${m4s_files[1]}"
    local output_name="$target_dir/${target_dir}_merged.mp4"

    echo "⏳ 剥离头部伪装..."
    tail -c +10 "$file1" > "$target_dir/temp_1.m4s"
    tail -c +10 "$file2" > "$target_dir/temp_2.m4s"

    echo "🎥 FFmpeg 混流中..."
    "$FFMPEG_CMD" -i "$target_dir/temp_1.m4s" -i "$target_dir/temp_2.m4s" -c:v copy -c:a copy "$output_name" -loglevel warning -y

    echo "🧹 清理临时文件..."
    rm -f "$target_dir/temp_1.m4s" "$target_dir/temp_2.m4s"

    echo "✅ 成功保存为: $output_name"
}

# 菜单选择逻辑
if [[ "$choice" == "all" ]]; then
    for d in "${dirs[@]}"; do
        process_dir "$d"
    done
    echo -e "\n================================================="
    echo "🎉 全部处理完毕！"
elif [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#dirs[@]}" ]; then
    idx=$((choice-1))
    process_dir "${dirs[$idx]}"
    echo -e "\n================================================="
    echo "🎉 单个任务处理完成！"
else
    echo "❌ 无效输入"
    exit 1
fi

