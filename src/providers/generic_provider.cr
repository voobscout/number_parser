abstract class NumberParser::GenericProvider
  def parse(str, ignore = [] of String, bias = :none)
    str = preprocess(str, ignore)
    str = numerize_numerals(str, ignore, bias)
    str = numerize_fractions(str, ignore, bias)
    str = numerize_ordinals(str, ignore, bias)
    str = numerize_big_prefixes(str, ignore, bias)
    str = postprocess(str, ignore)
    str
  end

  private abstract def preprocess(string, ignore)
  private abstract def numerize_numerals(string, ignore, bias)
  private abstract def numerize_fractions(string, ignore, bias)
  private abstract def numerize_ordinals(string, ignore, bias)
  private abstract def numerize_big_prefixes(string, ignore, bias)
  private abstract def postprocess(string, ignore)

  # Turns list of words into a unionized list, ignoring words specified in
  # arguments or that meet the conditions of the yield block
  private def regexify(words, ignore = [] of String)
    Regex.union(words.reject { |x| ignore.includes?(x) })
  end

  private def regexify(words, ignore = [] of String, &block)
    Regex.union(words.reject { |x| ignore.includes?(x) || yield(x) })
  end
end
