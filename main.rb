require 'set'

def open_file(file_name)
  # открываем файл и заносим таблицу переходов в Hash "table"
  table = { alphabet: [], states: [], state_transition: {}, finish: [], start: [] }
  lines = File.readlines(file_name)
  table[:alphabet] = lines[0].strip.split /\s+/
  lines = lines.drop 1
  set_state = Set.new []
  lines.each do |line|
    cur_line = line.strip.split /\s+/
    instance = cur_line[0]
    cur_line = cur_line.drop 1
    is_first = false
    if instance[0] == '~'
      throw 'too many start states' unless table[:start].empty?
      is_first = true
      instance.delete!('~')
      table[:start] = instance
    end
    table[:finish] << instance.gsub!(/[()]*/, '') if instance.match /\(.+\)/
    table[:states] << instance
    table[:state_transition][instance] = []
    cur_line.each do |el|
      trans = el.strip.split(/,/).sort
      set_state += trans
      throw 'to much transaction' unless table[:alphabet].size != trans.size
      table[:state_transition][instance] << trans
    end
  end
  set_state -= table[:states]
  set_state -= ['-']
  throw 'empty transition' unless set_state.empty?
  table
end

def determinization(table)
  new_table = { alphabet: [], states: [], state_transition: {}, finish: [], start: [] }
  new_table[:alphabet] = table[:alphabet]
  new_table[:start] = [table[:start]]
  help = [table[:start][0]]
  new_table[:state_transition][help] = table[:state_transition][table[:start][0]]
  q = []
  new_table[:state_transition][help].each do |state|
    q << state unless (q.include? state) || (state == ['-']) || new_table[:state_transition].key?(state)
  end
  until q.empty?
    b = q.shift
    res = []
    table[:alphabet].each_with_index do |symbol, i|
      new_transition = []
      b.each do |state|
        temp = table[:state_transition][state][i]
        next if temp == ['-']

        new_transition += temp
      end
      new_transition.uniq!
      new_transition.sort!
      new_transition = ['-'] if new_transition.empty?
      res << new_transition
    end
    new_table[:state_transition][b] = res

    res.each do |state|
      q << state unless (q.include? state) || (state == ['-']) || new_table[:state_transition].key?(state)
    end
  end

  orig_finish = Set.new table[:finish]
  new_table[:state_transition].each do |a, _|
    new_table[:states] << a
    z = Set.new a
    new_table[:finish] << a if a.size > (z - orig_finish).size
  end
  new_table
end

def write_to_file table, file
  fw = File.new file, 'w+'
  fw.print ' ' * 10
  table[:alphabet].each do |a|
    fw.print '%10s' % a
  end
  fw.print "\n"

  pp table

  table[:state_transition].each do |state, transitions|
    fw.print '~' if table[:start] == state
    if table[:finish].include? state
      fw.print '%10s' % '('+state.to_s.gsub(/['"\s\]\[]/, '')+')'
    else
      fw.print '%12s' % state.to_s.gsub(/['"\s\]\[]/, '')
    end

    fw.print "\t"

    transitions.each do |el|
      fw.print "%10s\t" % el.to_s.gsub(/['"\s\]\[]/, '')
    end

    fw.print "\n"
  end

end

a = open_file 'a.txt'
b = determinization a
write_to_file b, 'b.txt'
