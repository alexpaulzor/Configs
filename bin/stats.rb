total = 0.0
count = 0
max = nil
min = nil

while line = gets
	next if line == "\n"
	num = line.chomp.to_f
	#next if num > 4 * 1024 * 1024 || num < 0
	count += 1
	total += num

	min = num unless min 
	min = num if min > num

	max = num unless max
	max = num if max < num 
end

puts "count: #{count}"
puts "total: #{total}"
puts "avg: #{total / count}"
puts "min: #{min}"
puts "max: #{max}"
