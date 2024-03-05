extends GutTest


func test_empty() -> void:
	assert_eq([&""], DialogUI.split_into_lines(""))


func test_simple_string() -> void:
	assert_eq([&"abcd"], DialogUI.split_into_lines("abcd"))


func test_split_with_carriage_return() -> void:
	assert_eq([&"ab\ncd", &"efgh"], DialogUI.split_into_lines("ab\ncd\nefgh"))


func test_split_long_sentence() -> void:
	assert_eq(
		[
			&"a long sentence\nwith a lot of",
			&"small words",
		],
		DialogUI.split_into_lines("a long sentence with a lot of small words")
	)


func test_split_long_word() -> void:
	assert_eq(
		[
			&"this\nsentence_does_not_",
			&"have_spaces_and_is\n_longer_than_two_l",
			&"ines",
		],
		DialogUI.split_into_lines("this sentence_does_not_have_spaces_and_is_longer_than_two_lines")
	)
