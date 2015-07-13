class MarkovText

  attr_accessor :initial_text, :other_texts, :lump_texts

  # PredHash = Struct.new(:word, :predecessor)
  # Succ = Struct.new(:word, :successor)

  def initialize(initial_text, *other_texts)
    @initial_text = convert_text(initial_text)
    # an array of the files we will be combining the original with
    @other_texts = other_texts.inject([]){|memo, el| memo << convert_text(el)}
    @lump_texts = create_lump_texts
  end

  # store the length of the first text and combine that with the length fo all the other texts
  def population_size
    first_text_length = [@initial_text.split(" ").length]
    l2 = []
    @other_texts.each{|text| l2 << text.split(" ").length}
    (first_text_length + l2).inject(:+)
  end

  def split_initial
    @initial_text.split(" ")
  end

  def word_quantities
    h = {}
    s_t = @lump_texts.join(" ")
    j_t = s_t.split(" ").split(".").split(",")
    j_t.each do |el|
      if h[el]
        h[el] += 1
      else
        h[el] = 1
      end
    end
    p h

  end
  # Read each element, where an element is defined as a sequence of characters seperated by a space or quotation mark
  # before the first alphabetic or numeric character, and a space or punctuation after the last alphabetic or numeric character


  # each element will be a key in a hash like so: {"blah" => {""}}
  # compare this implementation vs the one commented out below

  def create_text_hashes

    hash = {}
    pop_size = population_size-2
    p1 = Time.now
    for i in 0...pop_size
      # notice that by creating this double that we can use tmp[0] in the first if clause, and tmp[1] inside that if clause, and only have iterated once
      tmp = [@lump_texts[i], @lump_texts[i+1]]
      if hash[tmp[0]]
        hash[tmp[0]] << tmp[1]
      else 
        hash[tmp[0]] = [tmp[1]]
      end
    end
    p2 = Time.now
    puts p2 - p1
    hash
  end

  # notice that we iterate three times in this implementation in the first if clause alone

  def create_text_hashes

    hash = {}
    pop_size = population_size-1

    for i in 0...pop_size
      if hash[@lump_texts[i]]
        hash[@lump_texts[i]] << @lump_texts[i+1]
      else 
        hash[@lump_texts[i]] = [@lump_texts[i+1]]
      end
    end
    hash
  end


  def convert_text(text)
    f = text
    puts text
    if text.match(".txt")
      f=open_and_parse_text_file(text)
    end
    f
  end

  def open_and_parse_text_file(filename)
    parsed_text = File.open(filename){|file| file.read}
    parsed_text.gsub(/\n/, " ").gsub("/\t/", " ")
  end

  def create_lump_texts
    @lump_texts = split_initial
    v = []
    @other_texts.each do |el|
      v.push el.split(" ")
    end
    @lump_texts +=  v.flatten!
    # @other_texts.map{|text| @lump_texts << text.split(" ")}
  end

  def create_random_text(len)
    h = create_text_hashes
    sentence = h.keys.sample.to_s
    temp_word = sentence
    words_count = 1
    while words_count < len
      sentence += " " + temp_word = h[temp_word].sample
      words_count += 1
    end
    puts sentence
  end
end


v = MarkovText.new("./markov_sample_texts/forrest_gump.txt", "./markov_sample_texts/ace_ventura.txt")

v.create_lump_texts

v.create_random_text(150)