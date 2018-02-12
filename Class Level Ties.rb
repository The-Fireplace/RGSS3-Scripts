# Class Level Ties v1.00 by The_Fireplace
# -- Difficulty Level: Normal
# -- Requires: Yanfly Class System

$imported = {} if $imported.nil?
$imported["Fireplace-ClassLevelTies"] = true

# @@Updates:
# 2018.02.11 - Initial Script Creation
# 
# @@Introduction:
# This script allows for classes' exp gain to be tied to the exp gain of other classes.
# Note that this script is made for the Yanfly Class System script with
# MAINTAIN_LEVELS disabled.
# 
# @@Installation Instructions:
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main.
# 
# @@Usage:
# Class Notetags - These notetags go in the class notebox in the database.
# <tied_to: x, y>
# -Ties the exp gain of classes with ids x and y to the exp gain of this class.
# <tied>
# -Prevents a class from directly earning exp. It will instead have to earn it from having
# another class tied_to it.
# 
# @@Compatibility:
# This script is made strictly for RPG Maker VX Ace. I cannot guarantee that it'll work
# on anything else.
# 
# This script requires Yanfly Engine Ace - Class System
# 
#==============================================================================
# If you edit anything beyond this point and break it, it's not up to me to fix it.
#==============================================================================

if $imported["YEA-ClassSystem"] && !YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
  
  module FIREPLACE
    module REGEXP
      module CLASS
        TIED = /<(?:TIED|tied)>/i
        TIED_TO = /<(?:TIED_TO|tied to):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
      end # CLASS
    end # REGEXP
  end # FIREPLACE
  
class Game_Actor < Game_Battler
  
  #Override XP earnings to check if a class is tied, or if it is tied to something.
  def change_exp(exp, show)
    @cexp = false
    self.class.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when FIREPLACE::REGEXP::CLASS::TIED
        @cexp = true#Do nothing to the XP because it is up to another class to change it.
      when FIREPLACE::REGEXP::CLASS::TIED_TO
        $1.scan(/\d+/).each { |num| 
        if $imported["YEA-ClassSpecifics"]
          @subreqmet = num.to_i > 0 && subclass_requirements_met?(num.to_i)
        end
        @exp[num.to_i] = [exp, 0].max if num.to_i > 0 && (unlocked_classes.include?(num.to_i) || YEA::CLASS_SYSTEM::DEFAULT_UNLOCKS.include?(num.to_i) || @subreqmet)
        }
      end
    } #end note.split
    @exp[@class_id] = [exp, 0].max unless @cexp
    last_level = @level
    last_skills = skills
    level_up while !max_level? && self.exp >= next_level_exp
    level_down while self.exp < current_level_exp
    display_level_up(skills - last_skills) if show && @level > last_level
    refresh
  end
end

end
