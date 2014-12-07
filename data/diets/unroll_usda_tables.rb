#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require_relative 'common'

module EatLessWell
  extend self

  def parse_usda_table(lines)
    foots = limtypes = units = nutrients = nil
    lines.each do |line|
      line.chomp!
      next if line.blank?
      row_type, life_stage, *vals = line.split("\t").map(&:strip)

      case row_type.downcase
      when ''           then foots = limtypes = units = nutrients = nil ; next
      when 'limtype'    then limtypes  = vals ; next
      when 'unit'       then units     = vals.map{|nut| fixup_unit(nut) } ; next
      when 'foot'       then foots     = vals ; next
      when 'group'      then nutrients = vals.map{|nut| fixup_nut(nut) } ; next
      when /^___+/     then return # done with this table
      when GROUP_RE then true   # continues below
      else
        warn "Weird row: #{row_type} #{line.inspect}" ; next
      end
      group = row_type

      lo_age, hi_age = lo_hi_age(life_stage)
      limtypes.each{|limtype| check_limtype(limtype) }

      biosex_and_population(group).each do |biosex, population|
        nutrients.zip(limtypes, units, foots, vals).each do |nutrient, limtype, (unit_top, unit_dem), foot, val|
          next if val.blank?
          warn "Blank limtype for #{[nutrient, limtype, unit_top, unit_dem, foot, val]}" if limtype.blank?

          fixup_val(limtype, val).each do |limtype, val, val_str, ref|
            puts [nutrient, lo_age, hi_age, population, biosex, limtype,
              val,
              # val_str,
              unit_top, unit_dem,
              # foot,
            ].join("\t")
          end
        end
      end

    end
  end
end

Pathname.of(:usda_tables).open do |raw_tables|
  100.times do |table_idx|
    EatLessWell.parse_usda_table(raw_tables)
    break if raw_tables.eof?
  end
end
