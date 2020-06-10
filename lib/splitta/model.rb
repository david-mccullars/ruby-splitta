#
# Naive Bayes model, with a few tweaks:
# - all feature types are pooled together for normalization (this might help
#   because the independence assumption is so broken for our features)
# - smoothing: add 0.1 to all counts
# - priors are modified for better performance (this is mysterious but works much better)
#
module Splitta
  class Model

    include Singleton

    LABELS = [0, 1]

    attr_reader :feats, :lower_words, :non_abbrs, :prior_probs

    def initialize
      @feats = model_read(:feats)
      @lower_words = model_read(:lower_words)
      @non_abbrs = model_read(:non_abbrs)

      @prior_probs = LABELS.each_with_object({}) do |label, h|
        h[label] = feats[[label, '<prior>']]**4
      end
    end

    def classify(doc)
      doc.frags.each do |frag|
        frag.pred = classify_one(frag)
      end
    end

    def inspect
      "#<Splitta::Model:#{object_id}>"
    end

    private

    def classify_one(frag)
      probs = prior_probs.dup
      LABELS.each do |label|
        frag.features(self).each do |f|
          key = [label, f.join('_')]
          next unless feats.include?(key)

          probs[label] *= feats[key]
        end
      end
      normalize(probs).fetch(LABELS.last)
    end

    def normalize(probs)
      total = probs.values.reduce(:+).to_f
      probs.transform_values do |value|
        value / total
      end
    end

    def model_read(name)
      Zlib::GzipReader.open(File.join(basedir, name.to_s)) do |gz|
        Marshal.load(gz)
      end
    end

    def basedir
      File.expand_path('../../data', __dir__)
    end

  end
end
