from pathlib import Path
from PIL import Image, ImageDraw

root = Path('/home/ubuntu/athr/evidence')
out = Path('/home/ubuntu/athr/screens_delivery')
out.mkdir(parents=True, exist_ok=True)

# Only observed emulator screenshots are listed. Missing or unverified flows
# are deliberately not fabricated as placeholders.
files = [
    ('Home', 'final_pass_home_latest_release.png'),
    ('Quran list', 'final_pass_quran_list_latest_release.png'),
    ('Mushaf and verse actions', 'final_pass_mushaf_verse_actions_latest_release.png'),
    ('Marker opens actions', 'final_pass_marker_opens_verse_actions_latest_release.png'),
    ('Quran audio playback', 'final_pass_quran_audio_player_latest_release.png'),
    ('Reciter selection', 'final_pass_reciter_picker_latest_release.png'),
    ('Azkar categories', 'final_pass_azkar_categories_latest_release_verified.png'),
    ('Azkar reading', 'final_pass_azkar_reading_latest_release.png'),
    ('Continuation Canvas', 'final_pass_home_continuation_latest_release.png'),
    ('Thread detail', 'final_pass_thread_detail_latest_release.png'),
    ('Prayer screen', 'final_pass_prayer_screen_latest_release.png'),
    ('Prayer notification', 'final_pass_prayer_notification_latest_release.png'),
]

thumb_w, thumb_h, label_h, cols = 270, 480, 46, 4
rows = (len(files) + cols - 1) // cols
sheet = Image.new('RGB', (cols * thumb_w, rows * (thumb_h + label_h)), '#e9eee9')
draw = ImageDraw.Draw(sheet)

for index, (label, filename) in enumerate(files):
    path = root / filename
    if not path.exists():
        continue
    image = Image.open(path).convert('RGB')
    image.thumbnail((thumb_w - 18, thumb_h - 18))
    card = Image.new('RGB', (thumb_w, thumb_h), 'white')
    card.paste(image, ((thumb_w - image.width) // 2, (thumb_h - image.height) // 2))
    x = (index % cols) * thumb_w
    y = (index // cols) * (thumb_h + label_h)
    sheet.paste(card, (x, y))
    draw.text((x + 10, y + thumb_h + 12), label, fill='#24352f')

sheet.save(out / 'athr_final_pass_contact_sheet.jpg', quality=90, optimize=True)
