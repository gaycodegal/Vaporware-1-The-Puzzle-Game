 
py_binary(
    name="check_music_channels",
    srcs=[
        "test/file_io.py",
        "test/tres_parse.py",
        "test/check_music_channels.py",
    ],
)

all_tscn = glob([
    "GodotProject/**/*.tscn"
])

py_test(
    name="multi_check_music_channels",
    srcs=[
        "test/file_io.py",
        "test/tres_parse.py",
        "test/check_music_channels.py",
        "test/multi_check_music_channels.py",
    ],
    args=all_tscn,
    data=all_tscn,
)
