-- Grid-based window manipulation

local mod={}

mod.config={
   grid_key = { {"Ctrl", "Alt", "Cmd"}, "g"},
   -- List of pairs to be passed as arguments to grid.setGrid()
   -- grid_geometries = { { "4x4" } }
   grid_geometries = { }
}

function mod.init()
   for i,v in ipairs(mod.config.grid_geometries) do
      logger.df("setGrid(%s, %s)", v[1], v[2])
      hs.grid.setGrid(v[1], v[2])
   end
   omh.bind(mod.config.grid_key, hs.grid.toggleShow)
end

return mod
