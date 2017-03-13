params ["_box", ["_restrict", false]];
private ["_magazines", "_weapons", "_backpacks", "_items", "_weaponsItemsCargo", "_box"];

_weapons = [];
_magazines = magazineCargo _box;
_items = itemCargo _box;
_backpacks = [];
_weaponsItemsCargo = weaponsItemsCargo _box;

if (count backpackCargo _box > 0) then {
	{
	_backpacks pushBack (_x call BIS_fnc_basicBackpack);
	} forEach backpackCargo _box;
};

// add everything inside _box containers.
{
	_magazines = _magazines + (magazineCargo (_x select 1));
	_items = _items + (itemCargo (_x select 1));
	_weaponsItemsCargo = _weaponsItemsCargo + weaponsItemsCargo (_x select 1);
} forEach everyContainer _box;


// get stuff inside the _weaponsItems
_result = [_weaponsItemsCargo] call AS_fnc_getWeaponItemsCargo;
_weapons = _weapons + (_result select 0);
_magazines = _magazines + (_result select 1);
_items = _items + (_result select 2);

// restrict to locked equipment.
if (_restrict) then {
	_weapons = _weapons - unlockedWeapons;
	_magazines = _magazines - unlockedMagazines;
	_items = _items - unlockedItems;
	_backpacks = _backpacks - unlockedBackpacks;
};

// build the vectors.
_weaponsFinal = [];
_weaponsFinalCount = [];
{
	_weapon = _x;
	if (not(_weapon in _weaponsFinal)) then {
		_weaponsFinal pushBack _weapon;
		_weaponsFinalCount pushBack ({_x == _weapon} count _weapons);
	};
} forEach _weapons;

_magazinesFinal = [];
_magazinesFinalCount = [];
{
	_magazine = _x;
	if (not(_magazine in _magazinesFinal)) then {
		_magazinesFinal pushBack _magazine;
		_magazinesFinalCount pushBack ({_x == _magazine} count _magazines);
	};
} forEach  _magazines;

_itemsFinal = [];
_itemsFinalCount = [];
{
	_item = _x;
	if (not(_item in _itemsFinal)) then {
		_itemsFinal pushBack _item;
		_itemsFinalCount pushBack ({_x == _item} count _items);
	};
} forEach _items;

_backpacksFinal = [];
_backpacksFinalCount = [];
{
	_backpack = _x;
	if (not(_backpack in _backpacksFinal)) then {
		_backpacksFinal pushBack _backpack;
		_backpacksFinalCount pushBack ({_x == _backpack} count _backpacks);
	};
} forEach _backpacks;

[[_weaponsFinal, _weaponsFinalCount], [_magazinesFinal, _magazinesFinalCount], [_itemsFinal, _itemsFinalCount], [_backpacksFinal, _backpacksFinalCount]]