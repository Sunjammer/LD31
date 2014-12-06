package com.furusystems.games.tower.generator;

/**
 * Abstract room described as graph node
 * @author Andreas Rønning
 */
class Room
{
	public var name:String;
	public var uid:Int;
	public var data:Dynamic;
	public var connections:IntHash<Room>;
	public var connectionCount:Int = 0;
	public function new(name:String = "Room", uid:Int = -1) 
	{
		this.name = name;
		this.uid = uid;
		connections = new IntHash<Room>();
	}
	public function connect(other:Room, oneWay:Bool = false ):Void {
		if (other == this) return;
		if (isConnected(other)) return;
		connections.set(other.uid, other);
		connectionCount++;
		if(!oneWay) other.connect(this);
	}
	public function hasConnections():Bool {
		return connectionCount != 0;
	}
	public function isConnected(other:Room):Bool {
		return connections.exists(other.uid);
	}
	
}