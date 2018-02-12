# Elemental Actors v1.00 by The_Fireplace
# -- Difficulty Level: Easy

$imported = {} if $imported.nil?
$imported["Fireplace-ElementalActors"] = true

# @@Updates:
# 2018.02.12 - Initial Script Creation
# 
# @@Introduction:
# This script modifies the elemental damage calculation to
# always take the actor's element(s) into account, rather than relying
# solely on the weapon's element.
# 
# @@Installation Instructions:
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main.
# 
# @@Usage:
# No end-user configuration necessary.
# 
# @@Compatibility:
# This script is made strictly for RPG Maker VX Ace. I cannot guarantee that it'll work
# on anything else.
# 
#==============================================================================
# If you edit anything beyond this point and break it, it's not up to me to fix it.
#==============================================================================

module RPG
  class BaseItem
    def atk_mods
      @atk_mods = {} unless @atk_mods
      return @atk_mods
    end
    
    def set_atk_mod(eid, val)
      @atk_mods = {} unless @atk_mods
      @atk_mods[eid] = val
    end
  end
end

class Game_Battler < Game_BattlerBase
  alias :item_element_rate_old :item_element_rate
  def item_element_rate(user, item)
    item.atk_mods if item.atk_mods == nil#Ensure that it isn't nil
    
    user.atk_elements.each do |element_id|
      item.set_atk_mod(element_id, 1.0 / user.atk_elements.size.to_f)
    end
    
    if item.atk_mods.empty?
      @resultmod = item_element_rate_old(user, item)
    else
      @resultmod = merged_element_rate(user, item)
      item.atk_mods.clear#Reset the added attack modifiers
    end
    return @resultmod
  end
  
  def merged_element_rate(user, item)
    return item.atk_mods.inject(0) do |r, (id, val)|
      r + element_rate(id) * val
    end
  end
end
