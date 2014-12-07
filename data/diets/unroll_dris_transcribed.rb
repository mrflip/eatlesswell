#!/usr/bin/env ruby

require_relative 'common'


module EatLessWell
  extend self
  def parse_usda_table(lines)
    lines.each_with_index do |line, ln|
      next if ln == 0
      line.chomp!
      vals = line.split("\t").map(&:strip)
      idx,nutrient,limtype,life_stage,biosex,val,unit,val_2,units_2,page,source,notes = vals
      next if nutrient.blank?

      biosex_pops, lo_age, hi_age = fixup_life_stage(life_stage)
      nutrient = fixup_nut(nutrient)
      # check_limtype(limtype) or (warn line.inspect  ; next )

      if biosex_pops.blank? ; then warn [vals, biosex_pops, lo_age, hi_age].inspect  ; next ; end

      unit_top, unit_dem = fixup_unit(unit)

      foot = ''

      biosex_pops.each do |biosex, population|
        fixup_val(limtype, val).each do |limtype, val, val_str, ref|
          puts [nutrient, lo_age, hi_age, population, biosex, limtype,
            val,
            # val_str
            unit_top, unit_dem,
            # foot,
          ].join("\t")
        end
      end
    end
  end


  def fixup_life_stage(life_stage)
    GROUP_AGE_RE.match(life_stage) or (warn "Funny life_stage #{life_stage.inspect}" ; return [])
    group, lo_age, hi_age = [$1, $2, $3]
    #
    biosex_pops = biosex_and_population(group)
    if (hi_age.blank?) then warn "no ages: #{life_stage.inspect}" ; return [biosex_pops] ; end
    #
    hi_age = (hi_age=="up" ? 120.0 : Float(hi_age))
    lo_age = (lo_age=='lo' ? 0.0   : Float(lo_age))
    lo_age, hi_age = lo_age/12, hi_age/12 if group == 'infant'
    [biosex_pops, lo_age, hi_age]
  end

end

EatLessWell.parse_usda_table(Pathname.of(:nas_table).open)
