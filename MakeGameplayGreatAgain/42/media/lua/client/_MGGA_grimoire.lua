-- Lua Grimoire [ Project Zomboid ] 
-- sources:
-- 1. https://demiurgequantified.github.io/ProjectZomboidLuaDocs
-- 2. https://demiurgequantified.github.io/ProjectZomboidJavaDocs 
-- 3. https://theindiestone.com/forums/index.php?/topic/9799-key-code-reference/ 

-- ... not all methods works, test it! 

-- ================================= RUNOMANCY : Basic Syntax

--[[ Inventory [ Basic Syntax ] { Lua } !
1. local var = value ; Declares a local variable
2. function name(params) ... end ; Defines a function
3. if condition then ... end ; Conditional statement
4. for i = 1, 10 do ... end ; Numeric for loop
5. while condition do ... end ; While loop
6. repeat ... until condition ; Repeat-until loop
7. table = {} ; Creates a new table
8. table.field = value ; Sets a field in a table
9. print(value) ; Outputs value to the console
10. -- comment ; Single-line comment
]]

--[[ Inventory [ Types and Literals ] { Lua, Basic Syntax }
1. nil ; Represents the absence of a value or a non-existent key in a table.
2. boolean ; Logical type with two values: true or false.
3. number ; Numeric type (integer or floating point) used for arithmetic and comparisons.
4. string ; Immutable sequence of characters, can be enclosed in single or double quotes, or long brackets .
5. table ; Associative array that can be used as lists, dictionaries, objects, etc.
6. function ; First-class value that can be stored in variables, passed as arguments, and returned.
7. userdata ; Type to store arbitrary C data, often representing objects from the host program.
8. thread ; Represents an independent coroutine, created with coroutine.create.
9. integer literal ; Whole numbers, e.g., 42, -7.
10. float literal ; Numbers with a decimal point, e.g., 3.14, -0.5.
11. string literal ; Text enclosed in quotes ("Hello") or brackets ().
12. boolean literal ; true or false keywords.
13. nil literal ; nil keyword, represents no value.
]]

-- ================================= TRANSMUTATION : Data 

--[[ Inventory [ Global Object Getters ] { B42, Project Zomboid } 
1. getDebug() ; Returns the current debug mode status (boolean)
2. getCameraOffY() ; Returns the camera's vertical offset (float)
3. createRegionFile() ; Creates a table containing all spawnpoints.lua files found in the vanilla folder and loaded mods
4. getMapDirectoryTable() ; Returns a table containing map directories
5. deleteSave(file: String) ; Deletes a specified save file
6. sendPlayerExtraInfo(player: IsoPlayer) ; Sends additional information about a player
7. getServerAddressFromArgs() ; Returns the server address from command-line arguments
8. getServerPasswordFromArgs() ; Returns the server password from command-line arguments
9. getServerListFile() ; Returns the server list file path
10. getPlayer() ; Returns the local player object (IsoPlayer)
11. getCell() ; Returns the current game cell (IsoCell)
12. getWorld() ; Returns the current game world (IsoWorld)
13. getLuaCacheDir() ; Returns the Lua cache directory path
14. getSandboxCacheDir() ; Returns the sandbox cache directory path
15. getLuaScriptDir() ; Returns the Lua script directory path
16. getLuaScriptFile(file: String) ; Returns the full path of a Lua script file
17. getLuaScriptFileName(file: String) ; Returns the file name of a Lua script file
18. getLuaScriptFilePath(file: String) ; Returns the path of a Lua script file
19. getLuaScriptFileNameNoExt(file: String) ; Returns the file name without extension
20. getLuaScriptFilePathNoExt(file: String) ; Returns the path without extension
21. getLuaScriptFileExt(file: String) ; Returns the extension of a Lua script file
22. getLuaScriptFileNameExt(file: String) ; Returns the file name with extension
23. getLuaScriptFilePathExt(file: String) ; Returns the path with extension
24. getLuaScriptFileNameNoExtNoPath(file: String) ; Returns the file name without extension and path
25. getLuaScriptFilePathNoExtNoPath(file: String) ; Returns the path without extension and path
26. getLuaScriptFileExtNoPath(file: String) ; Returns the extension without path
27. getLuaScriptFileNameExtNoPath(file: String) ; Returns the file name with extension, no path
28. getLuaScriptFilePathExtNoPath(file: String) ; Returns the path with extension, no path
]]

--[[ Inventory [ IsoPlayer Methods ] { Project Zomboid, Java API, Build 42 } !

-- IsoPlayer own methods:
1. toggleForceAim() : boolean — Toggles forced aiming mode. :contentReference[oaicite:0]{index=0}
2. toggleForceRun() : boolean — Toggles forced running. :contentReference[oaicite:1]{index=1}
3. toggleForceSprint() : boolean — Toggles forced sprinting. :contentReference[oaicite:2]{index=2}
4. update() : void — General per-frame update method. :contentReference[oaicite:3]{index=3}
5. updateLOS() : void — Updates line-of-sight logic. :contentReference[oaicite:4]{index=4}
6. updateMovementRates() : void — Updates internal movement speed calculations. :contentReference[oaicite:5]{index=5}
7. updateUsername() : void — Refreshes stored username if changed. :contentReference[oaicite:6]{index=6}
8. zombiesSwitchOwnershipEachUpdate() : boolean — Controls zombie ownership switching logic. :contentReference[oaicite:7]{index=7}
9. stopReceivingBodyDamageUpdates(player : IsoPlayer) : void — Stops body damage updates for the given player. :contentReference[oaicite:8]{index=8}
10. TestZombieSpotPlayer(movingObject : IsoMovingObject) : void — Tests if a zombie has spotted the player. :contentReference[oaicite:9]{index=9}

-- Static and other class methods:
11. allPlayersDead() : static boolean — Returns true if all players are dead. :contentReference[oaicite:10]{index=10}
12. allPlayersAsleep() : static boolean — Returns true if all players are asleep. :contentReference[oaicite:11]{index=11}
13. addMechanicsItem(itemid : String, part : VehiclePart, milli : Long) : void — Adds a mechanics-related item. :contentReference[oaicite:12]{index=12}
14. addWorldSoundUnlessInvisible(radius : int, volume : int, bStressHumans : boolean) : void — Triggers a world sound unless the player is invisible. :contentReference[oaicite:13]{index=13}
15. actionStateChanged(sender : ActionContext) : void — Called when action context changes. :contentReference[oaicite:14]{index=14}
16. updateEnduranceWhileSitting() : void — Updates endurance while sitting. :contentReference[oaicite:15]{index=15}
17. UpdateRemovedEmitters() : static void — Updates internal sound emitter list. :contentReference[oaicite:16]{index=16}

-- Inherited from IsoLivingCharacter:
18. AttemptAttack() : boolean — Attempts to initiate an attack. :contentReference[oaicite:17]{index=17}
19. isCollidedWithPushableThisFrame() : boolean — Checks if player collided with a pushable this frame. :contentReference[oaicite:18]{index=18}
20. isDoShove() : boolean — Checks if shove is active. :contentReference[oaicite:19]{index=19}
21. setDoShove(doShove : boolean) : void — Enables/disables shove. :contentReference[oaicite:20]{index=20}

-- Inherited from IsoGameCharacter:
22. [Many methods inherited—too numerous to list individually—covering: movement, actions, combat, appearance, dialogues, physiology, animations, inventory operations, traits, etc.] :contentReference[oaicite:21]{index=21}

-- Inherited from IsoMovingObject:
23. collideWith(obj : IsoObject) : void — Handles collision with another object. :contentReference[oaicite:22]{index=22}
24. [Many additional methods inherited—handling spatial movement, collisions, coordinates, positioning, etc.] :contentReference[oaicite:23]{index=23}

-- Inherited from IsoObject:
25. [Various rendering and object-level operations: name, container, sprite control, visibility, highlighting, offsets, interaction properties, etc.] :contentReference[oaicite:24]{index=24}

-- From java.lang.Object (inherited by all):
26. toString(), equals(), hashCode(), getClass(), wait(), notify(), etc. :contentReference[oaicite:25]{index=25}

27. isOutside() ; ... 

]]

--[[ Inventory [ IsoGameCharacter Methods ] { Project Zomboid, Java API, Build 42 } !

-- Core IsoGameCharacter own methods (from zombie.characters.IsoGameCharacter):
1. actionStateChanged(actionContext : ActionContext) : void — Called when an action state changes. :contentReference[oaicite:0]{index=0}
2. addBlood(bloodBodyPartType, showBleeding, addSplatter, renderFX) : void — Adds blood effect to a body part. :contentReference[oaicite:1]{index=1}
3. addHole(bloodBodyPartType) : void — Adds a hole to the specified body part (e.g. from damage). :contentReference[oaicite:2]{index=2}
4. calcHitDir(gameCharacter, handWeapon, vector2) : Float — Calculates hit direction based on attacker and weapon. :contentReference[oaicite:3]{index=3}
5. calculateBaseSpeed() : float — Returns character's base speed. :contentReference[oaicite:4]{index=4}
6. DoFootstepSound(soundOrVolume) : void — Triggers footstep audio (by name or by volume). :contentReference[oaicite:5]{index=5}
7. Eat(inventoryItem, [modifier]) : boolean — Consumes an item, returns success. :contentReference[oaicite:6]{index=6}
8. getInventory() : ItemContainer — Retrieves the character’s inventory container. :contentReference[oaicite:7]{index=7}
9. HasItem(itemType : String) : boolean — Checks if the character has an item. :contentReference[oaicite:8]{index=8}
10. PlayAnim(animName : String) : void — Plays a specified animation. :contentReference[oaicite:9]{index=9}
11. Say(text : String) : void — Character speaks the given text. :contentReference[oaicite:10]{index=10}
12. setAimAtFloor(flag : boolean) : void — Sets whether character aims at floor. :contentReference[oaicite:11]{index=11}
13. isRunning() / setRunning(flag : boolean) : [boolean / void] — Check or toggle running state. :contentReference[oaicite:12]{index=12}
14. isSprinting() / setSprinting(flag : boolean) : [boolean / void] — Check or toggle sprinting state. :contentReference[oaicite:13]{index=13}

-- Methods inherited from IsoMovingObject:
15. collideWith(obj : IsoObject) : void — Handles collision with another object. :contentReference[oaicite:14]{index=14}
16. getX(), getY(), getZ() : Coordinates — Returns world position. :contentReference[oaicite:15]{index=15}
17. Move(...) / DistTo(...) / other movement utilities — Spatial and pathfinding support. :contentReference[oaicite:16]{index=16}

-- Methods inherited from IsoObject:
18. addToWorld() : void — Adds this object to the game world. :contentReference[oaicite:17]{index=17}
19. getSquare() : IsoGridSquare — Gets the grid square the object is on. :contentReference[oaicite:18]{index=18}
20. setName(name : String) : void — Sets the object's name. :contentReference[oaicite:19]{index=19}
21. load() / save() : void — Serialization methods for persistence. :contentReference[oaicite:20]{index=20}

-- Methods inherited from java.lang.Object:
22. toString(), equals(), hashCode(), wait(), notify(), etc. — Standard Java object methods. :contentReference[oaicite:21]{index=21}

-- Methods inherited from interfaces:
23. getSquare(), getX(), getY(), getZ() — From ChatElementOwner (used in chat/rendering). :contentReference[oaicite:22]{index=22}
24. getOnlineID() — From IAnimatable; returns object’s online network ID. :contentReference[oaicite:23]{index=23}

]]

--[[ Inventory [ IsoGridSquare Methods ] { Project Zomboid, Java API, Build 42 } !

-- Methods from ProjectZomboid modding page:
1. getDoor(boolean north) : IsoObject — Retrieves a door in the specified direction. :contentReference[oaicite:0]{index=0}
2. getDoorFrameTo(IsoGridSquare next) : IsoObject — Retrieves the door frame between this square and the next. :contentReference[oaicite:1]{index=1}
3. getDoorOrWindow(boolean north) : IsoObject — Retrieves either a door or window in the specified direction. :contentReference[oaicite:2]{index=2}
4. getDoorOrWindowOrWindowFrame(IsoDirections dir, boolean ignoreOpen) : IsoObject — Retrieves door/window or its frame according to parameters. :contentReference[oaicite:3]{index=3}
5. getDoorTo(IsoGridSquare next) : IsoObject — Retrieves the door connecting to the neighboring square. :contentReference[oaicite:4]{index=4}
6. getE() : ErosionData.Square — Gets the erosion data for this square. :contentReference[oaicite:5]{index=5}
7. getErosionData() : ErosionData — Retrieves the erosion data object. :contentReference[oaicite:6]{index=6}
8. getGridSneakModifier(boolean onlySolidTrans) : float — Returns sneak modifier based on objects on this square. :contentReference[oaicite:7]{index=7}
9. getHashCodeObjects() : long — (Deprecated) Gets combined hash of objects. :contentReference[oaicite:8]{index=8}
10. getHashCodeObjectsInt() : int — (Deprecated) Integer variant of hash code. :contentReference[oaicite:9]{index=9}
11. getHasTypes() : ZomboidBitFlag — Returns type flags present on the square. :contentReference[oaicite:10]{index=10}
12. getHoppable(boolean north) : IsoThumpable — Returns an object you can hop over in the specified direction. :contentReference[oaicite:11]{index=11}
13. getHoppableThumpable(boolean north) : IsoThumpable — Same as above, specific to thumpable objects. :contentReference[oaicite:12]{index=12}
14. getHoppableThumpableTo(IsoGridSquare next) : IsoThumpable — Gets a thumpable object between squares. :contentReference[oaicite:13]{index=13}
15. getHoppableTo(IsoGridSquare next) : IsoObject — Retrieves a hoppable object between adjacent squares. :contentReference[oaicite:14]{index=14}
16. getHoppableWall(boolean bNorth) : IsoObject — Retrieves a wall that can be hopped over. :contentReference[oaicite:15]{index=15}
17. getHourLastSeen() : int — Returns the game hour when this square was last seen by a player. :contentReference[oaicite:16]{index=16}
18. getHoursSinceLastSeen() : float — Returns elapsed time since square was seen. :contentReference[oaicite:17]{index=17}
19. getID() : Integer — Unique identifier of the grid square. :contentReference[oaicite:18]{index=18}
20. getIsDissolved(int playerIndex, long currentTimeMillis) : boolean — Checks if square is dissolved (e.g. for shadows). :contentReference[oaicite:19]{index=19}
21. getIsoDoor() : IsoDoor — Directly fetches the door object, if any. :contentReference[oaicite:20]{index=20}
22. getIsoWorldRegion() : IWorldRegion — Returns the world region this square belongs to. :contentReference[oaicite:21]{index=21}
23. getLampostTotalB() : float — Returns total blue light contribution from lamp posts. :contentReference[oaicite:22]{index=22}
24. getLampostTotalG() : float — Returns total green light contribution from lamp posts. :contentReference[oaicite:23]{index=23}
25. getLampostTotalR() : float — Returns total red light contribution from lamp posts. :contentReference[oaicite:24]{index=24}
26. getLightcache() : static int — Returns the cached light value. :contentReference[oaicite:25]{index=25}
27. getLightInfluenceB() : ArrayList<Float> — Returns per-object blue light influence. :contentReference[oaicite:26]{index=26}
28. getLightInfluenceG() : ArrayList<Float> — Returns per-object green light influence. :contentReference[oaicite:27]{index=27}
29. getLightInfluenceR() : ArrayList<Float> — Returns per-object red light influence. :contentReference[oaicite:28]{index=28}
30. getLightLevel(int playerIndex) : float — Gets light level for the given player perspective. :contentReference[oaicite:29]{index=29}
31. getLocalTemporaryObjects() : PZArrayList<IsoObject> — Retrieves temporary objects on this square. :contentReference[oaicite:30]{index=30}
32. getLuaMovingObjectList() : KahluaTable — Lua-accessible list of moving objects. :contentReference[oaicite:31]{index=31}
33. getLuaTileObjectList() : KahluaTable — Lua-accessible list of tile objects. :contentReference[oaicite:32]{index=32}
34. getMatrixBit(int matrix, byte x, byte y, byte z) : static boolean — Gets a bit from internal collision matrix (byte coords). :contentReference[oaicite:33]{index=33}
35. getMatrixBit(int matrix, int x, int y, int z) : static boolean — Same as above but with int coords. :contentReference[oaicite:34]{index=34}
36. getModData() : KahluaTable — Retrieves a table for mod-related per-square data. :contentReference[oaicite:35]{index=35}
37. getMovingObjects() : ArrayList<IsoMovingObject> — List of moving objects on this square. :contentReference[oaicite:36]{index=36}

-- Additional methods from IndieStone JavaDoc:
38. addFloor(String sprite) : IsoObject — Adds a floor object using a specific sprite. :contentReference[oaicite:37]{index=37}
39. AddSpecialObject(IsoObject obj) : void — Adds a special object to this square. :contentReference[oaicite:38]{index=38}
40. AddSpecialTileObject(IsoObject obj) : void — Adds a special tile object. :contentReference[oaicite:39]{index=39}
41. AddStairs(boolean north, int level, String sprite, KahluaTable table) : IsoThumpable — Adds stairs and returns the thumpable object. :contentReference[oaicite:40]{index=40}
42. AddTileObject(IsoObject obj) : void — Adds a tile object (e.g., furniture). :contentReference[oaicite:41]{index=41}
43. AddWorldInventoryItem(InventoryItem item, float x, float y, float height) : InventoryItem — Places an inventory item physically in the world. :contentReference[oaicite:42]{index=42}
44. AddWorldInventoryItem(String type, float x, float y, float height) : InventoryItem — Same as above, using item type string. :contentReference[oaicite:43]{index=43}
45. Burn() : void — Sets this square on fire. :contentReference[oaicite:44]{index=44}
46. BurnWalls() : void — Burns any walls on this square. :contentReference[oaicite:45]{index=45}
47. BurnWallsTCOnly() : void — Burns walls under certain conditions (TC only). :contentReference[oaicite:46]{index=46}
48. CalcLightInfo() : void — Calculates lighting information for the square. :contentReference[oaicite:47]{index=47}
49. CalculateCollide(IsoGridSquare gridSquare, boolean bVision, boolean bPathfind, boolean bIgnoreSolidTrans) : boolean — Checks collision against another square. :contentReference[oaicite:48]{index=48}
50. CalculateCollide(IsoGridSquare gridSquare, boolean bVision, boolean bPathfind, boolean bIgnoreSolidTrans, boolean bIgnoreSolid) : boolean — Collision check with additional ignore flag. :contentReference[oaicite:49]{index=49}
51. CalculateVisionBlocked(IsoGridSquare gridSquare) : boolean — Checks if vision is blocked to another square. :contentReference[oaicite:50]{index=50}
52. ClearTileObjects() : void — Removes all tile objects. :contentReference[oaicite:51]{index=51}
53. ClearTileObjectsExceptFloor() : void — Clears objects but leaves the floor. :contentReference[oaicite:52]{index=52}
54. DeleteTileObject(IsoObject obj) : void — Deletes a specific tile object. :contentReference[oaicite:53]{index=53}
55. DirtySlice() : void — Marks the slice as dirty, triggering updates. :contentReference[oaicite:54]{index=54}
56. discard() : void — Discards this square. :contentReference[oaicite:55]{index=55}
57. DistTo(int x, int y) : float — Distance to specified (x, y). :contentReference[oaicite:56]{index=56}
58. DistTo(IsoGridSquare sq) : float — Distance to another grid square. :contentReference[oaicite:57]{index=57}
59. DistTo(IsoMovingObject other) : float — Distance to a moving object. :contentReference[oaicite:58]{index=58}
60. DistToProper(IsoMovingObject other) : float — More accurate distance calculation. :contentReference[oaicite:59]{index=59}
61. DoWallLightingN(...) : int — Wall lighting north direction. :contentReference[oaicite:60]{index=60}
62. DoWallLightingNW(...) : int — Wall lighting northwest. :contentReference[oaicite:61]{index=61}
63. DoWallLightingW(...) : int — Wall lighting west direction. :contentReference[oaicite:62]{index=62}
64. DoRoofLighting(...) : int — Roof lighting calculation. :contentReference[oaicite:63]{index=63}
65. EnsureSurroundNotNull() : void — Ensures surrounding squares are non-null. :contentReference[oaicite:64]{index=64}
66. FindEnemy(...) : IsoGameCharacter — Finds enemy within range. :contentReference[oaicite:65]{index=65}
67. FindFriend(...) : IsoGameCharacter — Finds friend within range. :contentReference[oaicite:66]{index=66}
68. getBedTo(IsoGridSquare next) : IsoObject — Retrieves bed between squares. :contentReference[oaicite:67]{index=67}
69. getCell() : IsoCell — Returns the cell this square belongs to. :contentReference[oaicite:68]{index=68}
70. getChunk() : IsoChunk — Retrieves the chunk. :contentReference[oaicite:69]{index=69}
71. getContainerItem(String type) : IsoObject — Retrieves a container of specified type. :contentReference[oaicite:70]{index=70}
72. getFloor() : IsoObject — Gets floor object. :contentReference[oaicite:71]{index=71}
73. getLuaMovingObjectList() : KahluaTable — Lua-accessible moving objects list. :contentReference[oaicite:72]{index=72}
74. getLuaTileObjectList() : KahluaTable — Lua-accessible tile objects list. :contentReference[oaicite:73]{index=73}
75. getModData() : KahluaTable — Mod data storage table for this square. :contentReference[oaicite:74]{index=74}
76. getObjects() : ArrayList<IsoObject> — All objects on this square. :contentReference[oaicite:75]{index=75}
77. getRoom() : IsoRoom — Room this square is part of. :contentReference[oaicite:76]{index=76}
78. getRoomID() : int — Room identifier. :contentReference[oaicite:77]{index=77}
79. getTileInDirection(IsoDirections directions) : IsoGridSquare — Neighboring square in a given direction. :contentReference[oaicite:78]{index=78}
80. getWall(boolean bNorth) : IsoObject — Retrieves a wall object in that direction. :contentReference[oaicite:79]{index=79}
81. isSafeToSpawn(IsoGridSquare sq, int depth) : boolean — Checks if it's safe to spawn at depth. :contentReference[oaicite:80]{index=80}
82. IsOnScreen() : boolean — Checks if this tile is currently visible on screen. :contentReference[oaicite:81]{index=81}
83. softClear() : void — Soft-clears dynamic state of the square. :contentReference[oaicite:82]{index=82}
84. save(...) / loadbytestream(...) : void/int — Serialization methods for saving/loading square state. :contentReference[oaicite:83]{index=83}
85. savebytestream(...) : int — Alternate serialization method. :contentReference[oaicite:84]{index=84}
86. getNew(IsoCell cell, SliceY slice, int x, int y, int z) : static IsoGridSquare — Factory method to create or get a square. :contentReference[oaicite:85]{index=85}
87. init(IsoCell cell, SliceY slice, int x, int y, int z) : void — Initializes the square. :contentReference[oaicite:86]{index=86}
88. interpolateLight(ColorInfo inf, float x, float y) : void — Interpolates lighting at coordinates. :contentReference[oaicite:87]{index=87}
89. setE(IsoGridSquare e) : void — Sets the erosion neighbor reference. :contentReference[oaicite:88]{index=88}
90. setLightInfluenceB/G/R(...) : void — Sets light influence values. :contentReference[oaicite:89]{index=89}
91. setLightInfo(ColorInfo lightInfo) : void — Sets main light info on square. :contentReference[oaicite:90]{index=90}
92. setDirty() : void — Marks square for update. :contentReference[oaicite:91]{index=91}
93. setID(int ID) : void — Assigns a unique ID to this square. :contentReference[oaicite:92]{index=92}
94. hasSupport() : boolean — Checks if square has structural support (e.g., floor). :contentReference[oaicite:93]{index=93}

— End of inventory —
]]

--[[ Inventory [ modData ] { PZ, B42 }
1. ModData.getOrCreate(key) ; Returns a persistent table tied to the given key, creating it if it doesn't exist.
2. ModData.add(key, table) ; Stores a given table as persistent data under the key.
3. ModData.remove(key) ; Deletes the persistent table stored under the key.
4. ModData.exists(key) ; Returns true if a persistent table exists for the given key.
5. ModData.transmit(key) ; Sends updated persistent table to other clients/servers in multiplayer.
6. Events.OnInitGlobalModData.Add(func) ; Event triggered after global modData has been loaded, used for initializing or updating defaults.
7. object:getModData() ; Returns a persistent table tied to the object (player, IsoObject, vehicle, inventory item, etc.).
8. player:getModData() ; Returns a persistent table tied to the specific player character.
9. inventoryItem:getModData() ; Returns a persistent table tied to the specific inventory item.
10. modData[key] = value ; Directly set persistent key-value pairs inside the modData table.
]]

--[[ Inventory [ IsoPlayer (boolean checkers) ] { PZ, B42 }
1. isPerformingAnAction() ; Returns true if the player is currently executing a timed action.  
2. isAttacking() ; Returns true if the player is in the middle of an attack.  
3. shouldBeTurning() ; Returns true if the player is in the process of turning.  
4. isGhostMode() ; Returns true if the player is in ghost mode (no clipping / noclip).  
5. hasInstance() ; Returns true if there is a valid `IsoPlayer` instance loaded.  
]]

--[[ Inventory [ IsoGridSquare Iso Getters ] { B42, PZ } !
1. square:getX() ; returns the grid X coordinate of this square (integer).
2. square:getY() ; returns the grid Y coordinate of this square (integer).
3. square:getZ() ; returns the Z-level (floor level) of this square (integer).
4. square:getObjects() ; returns an ArrayList of IsoObjects present on this square.
5. square:getMovingObjects() ; returns an ArrayList of IsoMovingObjects currently occupying this square.
6. square:getStaticMovingObjects() ; returns an ArrayList of IsoMovingObjects flagged as static.
7. square:getSpecialObjects() ; returns an ArrayList of IsoSpecialMoveables (special props) on this square.
8. square:getProperties() ; returns PropertyContainer with tile properties (metadata like “IsWater”, “IsSolidFloor”).
9. square:getChunk() ; returns IsoChunk this square belongs to.
10. square:getRoom() ; returns IsoRoom if the square is inside one, or nil if outside.
11. square:getBuilding() ; returns IsoBuilding if the square is inside a building, or nil otherwise.
12. square:getFloor() ; returns IsoObject representing the floor of this square (or nil).
13. square:getWall(dir) ; returns IsoObject wall in the given direction (N, S, E, W).
14. square:getWindow(dir) ; returns IsoWindow in the given direction, or nil.
15. square:getDoor(dir) ; returns IsoDoor in the given direction, or nil.
16. square:getTrapPosition() ; returns Vector3f with trap placement position (if any).
17. square:getPlayerRoom() ; returns IsoRoom specifically occupied by a player on this square.
18. square:getLampOnCeiling() ; returns IsoLightSwitch ceiling lamp (if present).
19. square:getS() ; returns adjacent IsoGridSquare to the South (or nil).
20. square:getN() ; returns adjacent IsoGridSquare to the North (or nil).
21. square:getE() ; returns adjacent IsoGridSquare to the East (or nil).
22. square:getW() ; returns adjacent IsoGridSquare to the West (or nil).
23. square:getAbove() ; returns IsoGridSquare directly above (z+1), or nil.
24. square:getBelow() ; returns IsoGridSquare directly below (z-1), or nil.
25. square:getZone() ; returns IsoMetaGrid.Zone associated with this square, or nil.
26. square:getTrapPosition() ; returns Vector3f where a trap would be placed in this square.
27. square:getObjectsLua() ; returns a Lua table of IsoObjects for iteration in Lua.
28. square:getFloorType() ; returns string name of the floor’s tile type.
29. square:getModData() ; returns ModData table (persistent custom key-value store).
30. square:getCell() ; returns IsoCell that contains this square.
31. getCompost() ; ...
32. getDeadBody()
33. getIsoDoor()
34. getSheetRope()
35. getStairsDirection()
36. getTree()
37. 
38.
->
->
->
->
->
->
->
->
->
->
->
->
->
->
]]

-- ================================= INCANTATION : User Interaction

--[[ Inventory [ UIElement Getters ] { PZ, B42 } !
1. getMaxDrawHeight() ; Double ; altura máxima de desenho
2. getXScroll() ; Double ; deslocamento no eixo X
3. getYScroll() ; Double ; deslocamento no eixo Y
4. getScrollHeight() ; Double ; altura total do conteúdo rolável
5. getScrollWidth() ; Double ; largura total do conteúdo rolável
6. getWidth() ; Double ; largura do elemento
7. getHeight() ; Double ; altura do elemento
8. getAbsoluteX() ; Double ; posição X absoluta na tela
9. getAbsoluteY() ; Double ; posição Y absoluta na tela
10. getParent() ; UIElement ; retorna o elemento pai
11. getTable() ; Object ; retorna a tabela de dados vinculada
12. getUIName() ; String ; nome interno do UIElement
13. getIsVisible() ; Boolean ; indica se o elemento está visível
14. getIsFocused() ; Boolean ; indica se o elemento está com foco
15. getAnchorRight() ; Boolean ; se está ancorado à direita
16. getAnchorBottom() ; Boolean ; se está ancorado embaixo
17. getMouseX() ; Double ; posição X do mouse relativa ao elemento
18. getMouseY() ; Double ; posição Y do mouse relativa ao elemento
19. getClipX() ; Double ; coordenada X da área de recorte
20. getClipY() ; Double ; coordenada Y da área de recorte
21. getClipWidth() ; Double ; largura da área de recorte
22. getClipHeight() ; Double ; altura da área de recorte
]]

--[[ Inventory [ Text Message Display ] { Project Zomboid – Java API } 
1. ChatMessage(ChatBase chat, String text) ; Constructor to create a chat message with content.
2. ChatMessage(ChatBase chat, LocalDateTime datetime, String text) ; Allows timestamped messages.
3. getText() ; Retrieves the raw message text from a ChatMessage.
4. setText(String text) ; Sets or changes the text of an existing ChatMessage.
5. getAuthor() / setAuthor(String author) ; Access or define the message's author.
6. getDatetimeStr() ; Retrieves a formatted timestamp as a string.
7. isShowInChat() / setShowInChat(boolean) ; Control whether the message appears in the chat UI.
8. isOverHeadSpeech() / setOverHeadSpeech(boolean) ; Designate message as floating above characters (overhead).
9. getTextColor() / setTextColor(Color color) ; Access or customize the message text color.
10. ChatElement.addChatLine(...) ; Adds a line of chat to display with styling and range parameters.
11. ChatElement.Say(String line) ; Sends a line of speech via Talker interface.
12. ChatElement.SayDebug(int n, String text) ; Sends a debug/discrete message, useful for testing.
13. TextManager.DrawString(...) ; Draws text to the screen at specified coordinates with color, font, transparency.
14. TextManager.DrawStringCentre(...) ; Centers and draws text on the screen.
15. TextManager.DrawStringBBcode(...) ; Renders text allowing BBCode formatting.
16. TextManager.GetDrawTextObject(...) ; Prepares a TextDrawObject for later rendering, with wrapping and restrictions.
17. TextDrawObject.Draw(...) ; Renders text (with options for outlines and alpha transparency).
]]

--[[ Inventory [ Events ] { B42, Project Zomboid } 
1. Events.OnCreatePlayer.Add(yourFunction) ; Registers a function to run when a player is created – yourFunction should accept a 'player' parameter.
2. Events.OnCreatePlayer.Remove(yourFunction) ; Unregisters a previously registered function from the OnCreatePlayer event.
3. Events.OnContainerUpdate.Add(callback) ; Hooks into container updates – callback receives the container as an argument.
4. Events.OnUseItem.Add(callback) ; Adds a callback for when an item is used, with parameters like character and item.
5. Events.OnGameStart.Add(callback) ; Fires when the game starts; used for early initialization logic.
6. Events.OnPostUIDraw.Add(callback) ; Called after the UI is drawn each frame—useful for custom rendering.
7. Events.OnZombieUpdate.Add(callback) ; Executes for each zombie each update tick; callback receives an IsoZombie instance.
8. Events.EveryOneMinute.Add(callback) ; Server-side event fired every in-game minute (noted in forums).
9. Events.OnClientCommand.Add(callback) ; Server-side event to listen for client commands.
10. Events.OnAddMessage.Add(callback) ; Client-side event triggered when a chat or message is received.
11. OnKeyPressed ; ... 

1. EveryOneMinute ; Fires every in-game minute — useful for periodic checks (e.g., adjust zoom based on player speed or environment).
2. EveryTenMinutes ; Fires every ten in-game minutes — could serve coarse checks, less frequent adjustments.
3. EveryHours ; Fires at the start of every in-game hour — for broad state resets or less frequent triggers.
4. EveryDays ; Fires at midnight in-game — ideal for reinitializing zoom settings daily.
5. OnCreatePlayer ; Fires when the local player is spawned — perfect for initial zoom setup per session.
6. OnClimateTick or OnClimateTickDebug ; Fires every climate tick (game tick) — excellent for real-time continuous adjustments, especially OnClimateTick for responsiveness.
7. OnContainerUpdate ; Fires when a container is added or removed — maybe lesser used, but could react to UI changes affecting zoom.
8. OnCustomUIKeyPressed / OnCustomUIKeyReleased ; Capture custom key events — ideal for toggle or manual override of auto-zoom.
9. OnAddMessage or OnAmbientSound ; Ambient triggers—could adapt zoom when events like helicopter or ambient sounds occur, adding situational focus.
10. OnLoadGridsquare or OnLoadChunk ; Fires when map squares or chunks are loaded — useful when entering new areas and adjusting zoom contextually.
]]

--[[ Inventory [ Time & Tick Events ] { B42, Project Zomboid }
-- Periodic time-based events
1. Events.EveryOneMinute.Add(callback) ; Executes once every in-game minute — ideal for frequent but lightweight updates.
2. Events.EveryTenMinutes.Add(callback) ; Executes once every ten in-game minutes — good for moderate interval tasks.
3. Events.EveryHours.Add(callback) ; Executes at the start of every in-game hour — suited for less frequent updates.
4. Events.EveryDays.Add(callback) ; Executes at midnight each in-game day — perfect for daily resets or summary logs.

-- Game loop tick events
5. Events.OnTick.Add(callback) ; Executes every game update tick — best for smooth, continuous logic like animations or auto-zoom.
6. Events.OnPlayerUpdate.Add(callback) ; Fires once per update tick for each player — ideal for player-specific checks.
7. Events.OnZombieUpdate.Add(callback) ; Fires once per update tick for each zombie — useful for AI or enemy tracking mods.
8. Events.OnVehicleUpdate.Add(callback) ; Fires every tick for each vehicle — useful for vehicle camera or physics mods.

-- Climate/environment tick events
9. Events.OnClimateTick.Add(callback) ; Fires when the climate system updates — good for weather-based logic.
10. Events.OnClimateTickDebug.Add(callback) ; Same as OnClimateTick but with debug hooks — useful for development/testing.

-- Rendering-related tick events
11. Events.OnRenderTick.Add(callback) ; Executes each render tick before drawing — useful for game-world visual changes.
12. Events.OnPostUIDraw.Add(callback) ; Fires after all UI elements are drawn — perfect for overlays or post-processing effects.
13. Events.OnRenderUpdate.Add(callback) ; Fires during render updates — can be used for per-frame visual adjustments.
14. Events.OnPostRender.Add(callback) ; Called after world rendering but before UI — useful for custom 3D overlays or effects.
]]

--[[ Inventory [ Key Event ] { Project Zomboid, B42 } !
1. Events.OnKeyPressed.Add(function(key)) ; Registers a callback triggered when any key is pressed. `key` is the virtual key code.
2. Events.OnKeyReleased.Add(function(key)) ; Registers a callback triggered when a key is released. `key` is the virtual key code.
3. getCore():getKey("ActionName") ; Retrieves the virtual key code for a specific player action (e.g., "Sprint", "Sneak"). Respects custom keybindings.
4. Keyboard.<KEY> ; Constant representing a specific key code (e.g., Keyboard.K, Keyboard.SPACE, Keyboard.ESC). Useful for comparison in key events.
5. stringToKeyCode(name) ; Custom helper function pattern to map a string like "K" to a key code using the Keyboard table.
6. key == Keyboard.<KEY> ; Common comparison pattern in OnKeyPressed/OnKeyReleased to check if a specific key was pressed.
7. Debug: print("Key pressed: "..tostring(key)) ; Useful for determining unknown key codes during development.
8. Action key loop: for action,_ in pairs(getCore():getKeyNames()) do ... end ; Iterates all player-configured keybindings to retrieve their virtual key codes.
]]

--[[ Inventory [ Zoom Control ] { Project Zomboid Java + Lua API } !
1. Core.getZoom(playerIndex) ; Returns the current zoom level for a player
2. Core.getMinZoom() ; Returns the minimum allowed zoom level
3. Core.getMaxZoom() ; Returns the maximum allowed zoom level
4. Core.getNextZoom(playerIndex, delta) ; Calculates the next zoom level based on scroll direction
5. Core.doZoomScroll(playerIndex, delta) ; Applies a zoom change (e.g., from mouse wheel scroll)
6. Core.isZoomEnabled() ; Returns true if zoom is enabled in the game settings
7. Core.setOptionZoom(boolean) ; Enables or disables zooming via settings
8. Core.getOptionZoom() ; Returns the current setting for zoom enabled/disabled
9. Core.zoomLevelsChanged() ; Triggers internal update when zoom levels are modified
10. Core.zoomOptionChanged(inGame) ; Updates zoom setting, usually after option menu changes
11. GlobalObject.screenZoomIn() ; Lua-exposed function to zoom in via scripting
12. GlobalObject.screenZoomOut() ; Lua-exposed function to zoom out via scripting
]]

--[[ Inventory [ Radial Menu Methods ] { Project Zomboid, Lua API, Build 42 } ! 

1. ISRadialMenu:new(player) ; Creates a new radial menu instance attached to the specified player.
2. radial:addSlice(label, texture, callback) ; Adds an option slice to the radial menu with a label, optional texture, and a callback function.
3. radial:show() ; Displays the radial menu, centered on the mouse cursor.
4. radial:clear() ; Removes all existing slices from the radial menu.
5. radial:removeSlice(label) ; Removes a slice by its label.
6. radial:setX(x) ; Sets the X-coordinate for the menu position.
7. radial:setY(y) ; Sets the Y-coordinate for the menu position.
8. radial:getSlices() ; Returns a table containing all current slices of the radial menu.
9. radial:updateSlice(label, newLabel, newTexture, newCallback) ; Updates an existing slice with new properties.
10. radial:setVisible(visible) ; Shows or hides the radial menu without destroying it.
11. radial:onSliceSelected(slice) ; Event handler called when a slice is selected (can be overridden).
]]

--[[ Inventory [ Context Menu ] { PZ, B42 }
1. Events.OnFillWorldObjectContextMenu.Add(func) * (playerIndex, context, worldobjects, test) ; Triggered to add custom options when right-clicking world objects.
2. Events.OnFillInventoryObjectContextMenu.Add(func) ; Triggered to add custom options when right-clicking items in the inventory.
3. ISContextMenu.getNew(parent) ; Creates a new context menu instance, usually inside an OnFill event.
4. context:addOption(text, target, function, ...) ; Adds a clickable option to the context menu, optionally passing parameters to the callback.
5. context:addDebugOption(text, target, function, ...) ; Adds a debug-only clickable option (visible in debug mode).
6. context:addSubMenu(text, submenu) ; Adds a nested submenu under the given text.
7. context:addOptionOnTop(text, target, function, ...) ; Adds a clickable option at the top of the menu.
8. ISContextMenu.createMenu(playerIndex, x, y) ; Creates and returns a blank context menu at the given position.
9. ISContextMenu.addOptionFromItem(context, item, function, ...) ; Adds a menu option using an item's name/icon.
10. context:removeOptionByName(text) ; Removes an option from the menu by its label.
]]

--[[ Inventory [ GUI ] { PZ, B42 }
1. ISPanel:new(x, y, w, h) ; Creates a basic rectangular UI panel without a title bar.
2. ISCollapsableWindow:new(x, y, w, h) ; Creates a draggable, resizable window with a title bar and close button.
3. ISPanel:initialise() ; Prepares the panel/window for use (must be called before adding to UI).
4. panel:addToUIManager() ; Adds the UI element to the screen so it’s visible and interactive.
5. panel:removeFromUIManager() ; Removes the UI element from the screen.
6. panel:setVisible(bool) ; Shows or hides the UI element without destroying it.
7. panel:addChild(childUI) ; Adds another UI element inside this panel.

-- Labels & Text
8. ISLabel:new(x, y, height, text, r, g, b, a, font, bLeft, parent) ; Displays static text.
9. ISRichTextPanel:new(x, y, w, h) ; Displays text with rich formatting (color, bold, etc.).
10. ISTextEntryBox:new(text, x, y, w, h) ; Creates an editable text input field.
11. ISTextBox:new(title, prompt, defaultText, onOkFunc, target, param1, param2) ; Modal text input dialog.

-- Buttons & Toggles
12. ISButton:new(x, y, w, h, title, clickTarget, clickFunc) ; Creates a clickable button.
13. ISTickBox:new(x, y, w, h, target, changeFunc) ; Creates a checkbox/toggle control.
14. ISTickBox:addOption(label, tooltip) ; Adds a selectable option to the tickbox.

-- Sliders & Numeric Controls
15. ISSliderPanel:new(x, y, w, h, target, changeFunc) ; Creates a horizontal slider control.
16. ISSpinner:new(x, y, w, h, target, changeFunc) ; Numeric input with increment/decrement buttons.

-- Images & Icons
17. ISImage:new(x, y, w, h, texture) ; Displays an image.
18. ISImageButton:new(x, y, w, h, texture, target, clickFunc) ; Button using an image instead of text.

-- Lists & Scrolling
19. ISScrollingListBox:new(x, y, w, h) ; Scrollable list container for rows of text or UI elements.
20. ISComboBox:new(x, y, w, h, target, changeFunc) ; Dropdown menu selection box.

-- Utility
21. panel:setAlwaysOnTop(bool) ; Forces UI element to render above others.
22. panel:setResizable(bool) ; Enables/disables resizing for windows.
23. panel:setCapture(bool) ; Forces the UI element to capture mouse input.
]]

--[[ Inventory [ Timed Action ] { B42, PZ }
1. ISBaseTimedAction:derive(name) ; Creates a subclass for custom timed actions.
2. action:new(character, ...) ; Constructor for the timed action, usually sets target, duration (maxTime), and other parameters.
3. action:isValid() ; Returns true if the action can start (override in subclass).
4. action:start() ; Called when the action begins (override to set animation or variables).
5. action:update() ; Called every game tick while action is running (override for movement, progress, or checks).
6. action:stop() ; Called if the action is interrupted (override to clean up state).
7. action:perform() ; Called when the action completes successfully (override to apply results and call ISBaseTimedAction.perform(self)).
8. ISTimedActionQueue.add(character, action) ; Adds a timed action to the player's action queue.
9. ISWalkToTimedAction:new(character, targetSquare, maxTime) ; Built-in timed action for walking to a specific IsoGridSquare with pathfinding.
10. character:setVariable(name, value) ; Often used in timed actions to trigger animations or state changes.
11. targetSquare:getX(), :getY(), :getZ() ; Access the position of the target grid square for movement or checks.
12. maxTime ; Field on the action representing duration in game ticks.
]]

--[[ Inventory [ Mouse Events ] { Project Zomboid, B42 }
1. Events.OnMouseDown.Add(func) ; Triggered when any mouse button is pressed. func(playerIndex, button) is called.
2. Events.OnMouseUp.Add(func) ; Triggered when a mouse button is released. func(playerIndex, button) is called.
3. Events.OnMouseWheelUp.Add(func) ; Triggered when the mouse wheel is scrolled up. func(playerIndex) is called.
4. Events.OnMouseWheelDown.Add(func) ; Triggered when the mouse wheel is scrolled down. func(playerIndex) is called.
5. Events.OnMouseMove.Add(func) ; Triggered when the mouse moves. func(playerIndex, x, y) is called.
6. ISMouseDrag:new() ; Base class for handling drag events (override update and perform for custom drag behavior).
7. ISMouseDrag:initialise() ; Initialize the drag event before adding it to a timed action queue or UI handling.
8. context:addOption(text, target, callback, ...) ; Can be used in combination with mouse right-click to attach actions.
9. context:addSubMenu(option, submenu) ; Attach a submenu to an option, triggered via right-click menu.
10. UIManager:getMouseX(), :getMouseY() ; Retrieve current mouse coordinates relative to the screen.
]]

--[[ Inventory [ Draw Texture/Image ] { PZ, B42 } !
1. getTexture("media/textures/file.png") ; loads a texture from mod's media/textures folder
2. drawTexture(tex, x, y, a, r, g, b) ; draws texture at position with alpha & color (panel context)
3. drawTextureScaled(tex, x, y, w, h, a, r, g, b) ; draws texture resized to width/height
4. drawTextureCentered(tex, x, y, a, r, g, b) ; draws texture centered at coordinates
5. drawTextureRotated(tex, x, y, angle, a, r, g, b) ; draws rotated texture at position
6. UIManager.DrawTexture(tex, x, y, a, r, g, b) ; draws texture directly on screen (global context)
7. UIManager.DrawTextureScaled(tex, x, y, w, h, a, r, g, b) ; global scaled texture drawing
8. UIManager.DrawTextureRotated(tex, x, y, angle, a, r, g, b) ; global rotated texture drawing
9. self:render() ; override in ISUIElement/ISPanel to draw textures inside custom UI
10. Events.OnRenderTick.Add(func) ; hook for drawing textures globally every frame
]]

--[[ Inventory [ Get Objects ] { B42, PZ }
1. getObjects() 
2. getMovingObjects() 
3. getSpecialObjects() 
4. getSquare() 
5. getItems() 
6. getContainer() 
7. getItemContainer() 
]]

--[[ Inventory [ Keyboard ] {PZ, B42}
1. isKeyDown(String string)
2. isKeyPressed(String string)
3. 
]]

--[[ Inventory [ User Interface Elements Creation ] { PZ, B42 } !
1. ISPanel:new(x, y, width, height) ; cria um painel básico/container
2. ISButton:new(x, y, width, height, text, target, onClick) ; cria um botão interativo
3. ISCollapsableWindow:new(x, y, width, height) ; cria uma janela colapsável e arrastável
4. ISScrollingListBox:new(x, y, width, height) ; cria uma lista rolável
5. ISRichTextPanel:new(x, y, width, height) ; cria um painel de texto com formatação
6. ISTabPanel:new(x, y, width, height) ; cria um painel de abas
7. ISCollapsablePanel:new(x, y, width, height) ; cria um painel colapsável simples
8. ISSlider:new(x, y, width, height, horizontal, parent, target, onChange) ; cria um controle deslizante
9. ISCheckbox:new(x, y, width, height, text, parent, target, onChange) ; cria uma caixa de seleção
10. ISTickBox:new(x, y, width, height, text, parent, target, onChange) ; similar ao ISCheckbox, usada em listas
11. ISTextEntryBox:new(text, x, y, width, height) ; cria um campo de texto editável
]]


























