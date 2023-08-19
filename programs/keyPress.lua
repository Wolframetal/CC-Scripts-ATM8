while true do
  print( "Press E to do something." )
  
  local event, key = os.pullEvent( "key" ) -- limit os.pullEvent to the 'key' event
  
  if key == keys.e then -- if the key pressed was 'e'
    print( "You pressed [E]. Exiting program..." )
    break
  end
end