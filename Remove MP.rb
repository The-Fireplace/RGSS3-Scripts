# Remove MP v1.00 by The_Fireplace
# -- Difficulty Level: Easy

$imported = {} if $imported.nil?
$imported["Fireplace-ElementalActors"] = true

# @@Updates:
# 2018.02.27 - Initial Script Creation
# 
# @@Introduction:
# This script removes MP from being seen by the user. Players will have no way to
# see how much MP they have.
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
# Note that this script has not yet been tested without Yanfly Battle Engine loaded.
# 
#==============================================================================
# If you edit anything beyond this point and break it, it's not up to me to fix it.
#==============================================================================


class Window_Base < Window
  def draw_actor_mp(actor, x, y, width = 124)
    #Draw nothing.
  end
end

#Hide it from the class screen
if $imported["YEA-ClassSystem"]
  class Window_ClassParam < Window_Base
    
    #Override this to not draw MP, and distribute the gap left between remaining stats (*8/7)
    def refresh
      contents.clear
      8.times {|i|
      draw_item(0, line_height * i * 8/7, i) if i == 0
      draw_item(0, line_height * (i-1) * 8/7, i) if i > 1
      }
    end
    
  end
end

if $imported["YEA-BattleEngine"]
  class Game_Actor < Game_Battler
    
    def draw_mp?
      return false
    end
    
  end
end
