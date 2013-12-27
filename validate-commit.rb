#!/usr/bin/ruby

summary_length = 50
line_length = 72

editor =  ENV['EDITOR'] || 'vim'
commit_file = ARGV[0]

while true do
  message =  File.read(commit_file)
  errors = []
  lines = message.lines.to_a

  if lines.first.end_with? '.' && !lines.first.start_with?('#')
    errors << "Commit message summaries should not end with a period"
  end

  if lines.first.length > summary_length && !lines.first.start_with?('#')
    errors <<
    "Commit message summary should be less than #{summary_length} characters"
  end

  first_line = lines.at(1) && lines.at(1).chomp
  puts "1: #{first_line}"
  puts "1: #{first_line.empty?}"
  if first_line && !first_line.empty?
    errors <<
    "Commit messages should have an empty line between the summary and body"
  end

  if lines.find { |line| line.length > line_length && !line.start_with?('#') }
    errors <<
    "Commit messages shouldn't have any lines over #{line_length} characters"
  end

  if errors.empty?
    exit(0)
  else
    puts "Commit Aborted"
    errors.each do |error|
      puts "  #{error}"
    end
    puts "\nWould you like to edit the message now? (Y/n)"
    choice = STDIN.gets.chomp.downcase
    if choice.empty? || choice == 'y'
      File.open(commit_file, 'w') do |f|
        f.write message
        f.write "\n"
        f.write "# Commit Message Errors:"
        error_prefix = "\n#   "
        f.write error_prefix << errors.join(error_prefix)
      end
      system "#{editor} #{commit_file}"
      next
    else
      exit(1)
    end
  end
end


