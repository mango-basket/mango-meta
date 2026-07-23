module io

export fn print(string: [char]) {
	var i = 0
	while string[i] as int != 0 {
		disp string[i]
		i = i + 1
	}
}

