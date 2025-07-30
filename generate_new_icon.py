#!/usr/bin/env python3
"""
AI卡路里应用图标生成器
设计一个结合AI和营养追踪概念的现代化图标
"""

from PIL import Image, ImageDraw, ImageFont
import math
import os

def create_ai_calories_icon(size=1024):
    

    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    

    bg_color = (74, 144, 226)
    accent_color = (255, 107, 107)
    ai_color = (138, 201, 38)
    white = (255, 255, 255)
    dark_blue = (45, 90, 150)
    

    corner_radius = size // 8
    draw.rounded_rectangle(
        [(0, 0), (size, size)], 
        radius=corner_radius, 
        fill=bg_color
    )
    

    for i in range(size//4):
        alpha = int(30 * (1 - i/(size//4)))
        overlay = Image.new('RGBA', (size, size), (255, 255, 255, alpha))
        img = Image.alpha_composite(img, overlay)
    

    draw = ImageDraw.Draw(img)
    

    center_x, center_y = size // 2, size // 2
    plate_radius = size // 3.5
    

    draw.ellipse(
        [center_x - plate_radius, center_y - plate_radius, 
         center_x + plate_radius, center_y + plate_radius],
        fill=white,
        outline=dark_blue,
        width=size//80
    )
    

    food_radius = plate_radius // 4
    

    apple_x = center_x - plate_radius // 2.5
    apple_y = center_y - plate_radius // 3
    draw.ellipse(
        [apple_x - food_radius//2, apple_y - food_radius//2,
         apple_x + food_radius//2, apple_y + food_radius//2],
        fill=accent_color
    )
    

    veggie_x = center_x + plate_radius // 3
    veggie_y = center_y - plate_radius // 4
    draw.ellipse(
        [veggie_x - food_radius//2, veggie_y - food_radius//2,
         veggie_x + food_radius//2, veggie_y + food_radius//2],
        fill=ai_color
    )
    

    yellow_x = center_x
    yellow_y = center_y + plate_radius // 3
    draw.ellipse(
        [yellow_x - food_radius//2, yellow_y - food_radius//2,
         yellow_x + food_radius//2, yellow_y + food_radius//2],
        fill=(255, 193, 7)
    )
    

    ai_size = size // 12
    ai_positions = [
        (size - size//6, size//6),
        (size - size//8, size//4),
        (size - size//4, size//8)
    ]
    
    for pos in ai_positions:
        draw.ellipse(
            [pos[0] - ai_size//2, pos[1] - ai_size//2,
             pos[0] + ai_size//2, pos[1] + ai_size//2],
            fill=ai_color,
            outline=white,
            width=size//200
        )
    

    for i in range(len(ai_positions) - 1):
        draw.line(
            [ai_positions[i], ai_positions[i+1]],
            fill=white,
            width=size//150
        )
    

    try:

        font_size = size // 8
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
    except:

        font = ImageFont.load_default()
    

    ai_text = "AI"
    ai_bbox = draw.textbbox((0, 0), ai_text, font=font)
    ai_text_width = ai_bbox[2] - ai_bbox[0]
    ai_text_height = ai_bbox[3] - ai_bbox[1]
    
    ai_text_x = size//8
    ai_text_y = size - size//4
    

    padding = size//40
    draw.rounded_rectangle(
        [ai_text_x - padding, ai_text_y - padding,
         ai_text_x + ai_text_width + padding, ai_text_y + ai_text_height + padding],
        radius=size//60,
        fill=ai_color
    )
    
    draw.text((ai_text_x, ai_text_y), ai_text, fill=white, font=font)
    

    cal_text = "Cal"
    cal_bbox = draw.textbbox((0, 0), cal_text, font=font)
    cal_text_width = cal_bbox[2] - cal_bbox[0]
    cal_text_height = cal_bbox[3] - cal_bbox[1]
    
    cal_text_x = size - size//8 - cal_text_width
    cal_text_y = size - size//4
    

    draw.rounded_rectangle(
        [cal_text_x - padding, cal_text_y - padding,
         cal_text_x + cal_text_width + padding, cal_text_y + cal_text_height + padding],
        radius=size//60,
        fill=accent_color
    )
    
    draw.text((cal_text_x, cal_text_y), cal_text, fill=white, font=font)
    
    return img

def generate_all_icon_sizes():
    sizes = {
        'icon_1024.png': 1024,
        'icon_180.png': 180,
        'icon_152.png': 152,
        'icon_120.png': 120,
        'icon_76.png': 76
    }
    
    base_dir = '/Users/weifu/Desktop/AI卡路里'
    new_icons_dir = os.path.join(base_dir, 'NewAppIcons')
    os.makedirs(new_icons_dir, exist_ok=True)
    
    for filename, size in sizes.items():
        print(f"生成 {filename} ({size}x{size})")
        icon = create_ai_calories_icon(size)
        icon_path = os.path.join(new_icons_dir, filename)
        icon.save(icon_path, 'PNG', quality=100)
        print(f"保存到: {icon_path}")
    
    print(f"\n所有图标已生成到: {new_icons_dir}")
    return new_icons_dir

if __name__ == "__main__":
    try:
        new_icons_dir = generate_all_icon_sizes()
        print("✅ 所有AI卡路里图标生成完成！")
    except Exception as e:
        print(f"❌ 生成图标时出错: {e}")