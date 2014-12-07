# -*- coding: utf-8 -*-

require 'gorillib'
Object.class_eval do ; def try(*a, &b) ; if (a.empty? && block_given?) then yield self ; elsif (!a.empty? && !respond_to?(a.first, true)) then nil ; else __send__(*a, &b) ; end ; end ; end

require 'gorillib/model'
require 'gorillib/pathname'

Pathname.register_paths(
  data_dir:    '..',
  usda_tables: [:data_dir, 'diets', ARGV[0] || 'dris_via_usda.tsv'],
  nas_table:   [:data_dir, 'diets', ARGV[0] || 'dris_transcribed.tsv'],
  )

module EatLessWell
  extend self

  MU_GRAMS = /μg/
  NUM      = '[\\d\\.,]+'

  GROUP_RE  = %r{\A(Infants|Children|Males|Females|Pregnancy|Lactation)\z}i
  AGE_RE    = %r{\A(#{NUM})[-–−](#{NUM}|up) (y|mo)$}
  GROUP_AGE_RE = %r{\A(infant|child|male|female|pregnant|lactating|adult|all)(?:_(\d+|lo)_(\d+|up))?\z}
  LIMTYPE_RE   = %r{\AEAR|RDA|UL|AI|AMDR|LU|LD\z}
  FOOT_RE   = %r{\A[a-k]}
  UNIT_RE   = %r{(?: (ug|mg|g|pct|L) (/day|\sEnergy|/kg/day) )}x
  HYPHENATED_VAL = /^([\d\.,]+)[-–]([\d\.,]+)$/


  SHORT_NAMES = {
    'Fat, total' => 'fat',
    'Fat, n-6 polyunsaturated fatty acids (linoleic acid)' => 'fat_n6_lnlc',
    'Fat, n-3 polyunsaturated fatty acids (α-linolenic acid)' => 'fat_n3_alph',
    'Dietary cholesterol' => 'cholesterol',
    'Trans fatty Acids' => 'fat_trans',
    'Saturated fatty acids' => 'fat_sat',
    'Added sugars' => 'sugar_add',
    'Total Water' => 'water_tot',
    'Linolenic Acid' => 'fat_n6lnlc',
    'α-Linolenic Acid' => 'fat_n3alph',
    'Linoleic Acid' => 'fat_n6lnlc',
    'LinAcid' => 'fat_n6lnlc',
    'Alpha-LinAcid' => 'fat_n3alph',
    'Total Beverage' => 'beverage_tot'

  }
  NUTRIENTS = [].to_set

  def fixup_val(limtype, val)
    case val
    when /^#{NUM}$/
      [[limtype, Float(val.gsub(/,/,'')), val]]
    when HYPHENATED_VAL
      lo, hi = [$1, $2]
      [ ["#{limtype}-lo", Float(lo.gsub(/,/,'')), lo.to_s],
        ["#{limtype}-hi", Float(hi.gsub(/,/,'')), hi.to_s], ]
    when 'ND'
      [[limtype, nil, val, nil]]
    when /^(#{NUM}|ND):(LU):?(\w+)?$/
      # this is our shorthand for "No UL given but they say not to eat it"
      [ [limtype, nil,     val  ],
        ['LU',    $1.to_f, val  ]  ]
    when /^(ND):(fn):?(\w+)?$/
      # this is our shorthand for "None given, but see footnote"
      [ [limtype, nil,     val  ]  ]
    else
      warn "Funny value: #{val.inspect}"
      [[-99, val, nil]]
    end
  end

  def check_limtype(limtype)
    return true if (LIMTYPE_RE === limtype) || (limtype.blank?)
    warn "funny-looking limtype #{limtype.inspect}"
    false
  end

  def fixup_nut(nut)
    nut = 'pant_acid'            if nut =~ /^pant.*c acid$/i
    nut = 'carotnds'             if nut =~ /^cart.*ds$/i
    nut = SHORT_NAMES[nut]       if SHORT_NAMES.include?(nut)
    nut.gsub!(/^Vitamin /, 'Vit ')
    nut.gsub!(/^Vit B-/, 'Vit B')
    #
    warn "Long nutrient #{nut}"  if nut.length > 12
    warn "Funny nutrient #{nut}" if nut =~ /[^\w\s]/
    nut.downcase.gsub(/ /, '_')
  end

  def fixup_unit(unit)
    return [nil, nil] if unit.blank?
    unit.gsub!(MU_GRAMS, 'ug')
    unit.gsub!(/%/,      'pct')
    if unit =~ UNIT_RE
      [$1, $2]
    else
      warn "Funny unit: #{unit.inspect}"
      [unit, '']
    end
  end

  def biosex_and_population(group)
    # Biological sex and group
    case group.to_s.downcase
    when /^males?$/           then [[:male,   :typical  ]]
    when /^females?$/         then [[:female, :typical  ]]
    when /^adult$/            then [[:male,   :typical  ], [:female,   :typical  ]]
    when /^all$/              then [[:male,   :typical  ], [:female,   :typical  ], [:female, :pregnant ], [:female, :lactating ], [:male,   :infant],  [:female, :infant], [:male,   :child],     [:female, :child]]
    when /^infants?$/         then [[:male,   :infant],    [:female, :infant]]
    when /^child(?:ren)?$/    then [[:male,   :child],     [:female, :child]]
    when /^pregnan(?:t|cy)$/  then [[:female, :pregnant ]]
    when /^lactati(?:on|ng)$/ then [[:female, :lactating]]
    else
      warn "weird life group: #{group.inspect}"
    end
  end

  # Age group -- convert to years
  def lo_hi_age(life_stage)
    AGE_RE.match(life_stage) or warn "Funny life_stage #{life_stage.inspect}"
    lo_age, hi_age, yr = [Float($1), ($2=="up" ? 120.0 : Float($2)), $3]
    lo_age, hi_age = lo_age/12, hi_age/12 if (yr == 'mo')
    [lo_age, hi_age]
  end

end
