$resettime = true
$newline = true

$starttime = Time::now

class String
  def timestampify
    self.each_byte.map do |byte|
      if $resettime then
        $resettime = false
        $starttime = Time::now
      end

      if $newline then
        $newline = false unless byte == "\n"

        ts = "\e[33m%9.4f \e[0m" % (Time::now - $starttime)

        next ts.codepoints + [ byte ]
      end

      if byte == "\n".ord then
        $newline = true
      end

      [ byte ]
    end.to_a.flatten.pack("c*")
  end
end

File::open("itm.fifo") do |f|
  loop do
    header = f.read(1)

    case header
    when "\x01"
      STDOUT.write f.read(1).timestampify
    when "\x02"
      STDOUT.write f.read(2).timestampify
    when "\x03"
      STDOUT.write f.read(4).timestampify
    when nil
      puts "\e[34;1m- EOF -\e[0m"
      $resettime = true
    end
  end
end
