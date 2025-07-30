#!/usr/bin/env python3
"""
从源图标生成所有需要的应用图标尺寸
"""

from PIL import Image
import os

def resize_icon_to_all_sizes(source_path):
    

    if not os.path.exists(source_path):
        print(f"❌ 源文件不存在: {source_path}")
        return False
    
    try:

        source_img = Image.open(source_path)
        print(f"✅ 成功打开源图像: {source_img.size}")
        

        if source_img.mode != 'RGBA':
            source_img = source_img.convert('RGBA')
        

        sizes = {
            'icon_1024.png': 1024,
            'icon_180.png': 180,
            'icon_152.png': 152,
            'icon_120.png': 120,
            'icon_76.png': 76
        }
        
        base_dir = '/Users/weifu/Desktop/AI卡路里'
        new_icons_dir = os.path.join(base_dir, 'FinalAppIcons')
        os.makedirs(new_icons_dir, exist_ok=True)
        
        for filename, size in sizes.items():
            print(f"生成 {filename} ({size}x{size})")
            

            resized_img = source_img.resize((size, size), Image.Resampling.LANCZOS)
            

            icon_path = os.path.join(new_icons_dir, filename)
            resized_img.save(icon_path, 'PNG', quality=100, optimize=True)
            print(f"✅ 保存到: {icon_path}")
        
        print(f"\n🎉 所有图标已生成到: {new_icons_dir}")
        return new_icons_dir
        
    except Exception as e:
        print(f"❌ 处理图像时出错: {e}")
        return False

if __name__ == "__main__":
    source_path = '/Users/weifu/Desktop/AI卡路里/source_icon.png'
    result = resize_icon_to_all_sizes(source_path)
    
    if result:
        print("✅ 图标生成完成！")
    else:
        print("❌ 图标生成失败！")