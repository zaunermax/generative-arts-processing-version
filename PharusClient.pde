
// Version 3.1
// this class replaces former TUIOHelper in this new and enhanced implementation
// do not change anything in here unless you are really sure of what you are doing

import java.lang.*;
import java.lang.reflect.*;
import processing.core.*;
import TUIO.*;
import java.util.*;

// reference: https://github.com/processing/processing/wiki/Library-Basics
public class PharusClient extends PApplet 
{
  // internal stuff only
  PApplet parent;
  TuioProcessing tuioProcessing;
  int nextUniqueID = 0;
  Method playerAddEventMethod;
  Method playerRemoveEventMethod;
  int wallHeight = 0;

  boolean doDebug = false;  
  int maxAge = 50; // age is measured in update cycles, with 25 fps this is 2 seconds
  float jumpDistanceMaxTolerance = 0.05f; // max distance allowed when jumping between last known position and potential landing position, unit is in pixels relative to window width
  HashMap<Long, Player> players = new HashMap<Long, Player>();

  PharusClient(PApplet _parent, int _wallHeight) 
  {
    this.parent = _parent;
    this.wallHeight = _wallHeight;
    // this is a bit of a hack but need for TuioProcessing to work properly
    width = parent.width;
    height = parent.height;
    tuioProcessing = new TuioProcessing(this); 

    parent.registerMethod("dispose", this);
    parent.registerMethod("pre", this); 

    // check to see if the host applet implements event functions
    try 
    {
      playerAddEventMethod = parent.getClass().getMethod("pharusPlayerAdded", new Class[] { Player.class });
    } 
    catch (Exception e) 
    {
      // no such method, or an error..
      println("Function pharusPlayerAdded() not found, Player add events disabled.");
    }
    try 
    {
      playerRemoveEventMethod = parent.getClass().getMethod("pharusPlayerRemoved", new Class[] { Player.class });
    } 
    catch (Exception e) 
    {
      // no such method, or an error..
      println("Function pharusPlayerRemoved() not found, Player remove events disabled.");
    }    
  }
  
  // age is measured in update cycles, with 25 fps this is 2 seconds
  public void setMaxAge(int age)
  {
    maxAge = age;
  }

  // max distance allowed when jumping between last known position and potential landing position, unit is in pixels relative to window width
  public void setjumpDistanceMaxTolerance(float relDist)
  {
    jumpDistanceMaxTolerance = relDist;
  }

  void firePlayerAddEvent(Player player) 
  {
    if (playerAddEventMethod != null) 
    {
      try 
      {
        playerAddEventMethod.invoke(parent, new Object[] { player });
      } 
      catch (Exception e) 
      {
        System.err.println("Disabling event for " + playerAddEventMethod.getName() + " because of an error.");
        e.printStackTrace();
        playerAddEventMethod = null;
      }
    }
  }
  
  void firePlayerRemoveEvent(Player player) 
  {
    if (playerRemoveEventMethod != null) 
    {
      try 
      {
        playerRemoveEventMethod.invoke(parent, new Object[] { player });
      } 
      catch (Exception e) 
      {
        System.err.println("Disabling event for " + playerRemoveEventMethod.getName() + " because of an error.");
        e.printStackTrace();
        playerRemoveEventMethod = null;
      }
    }
  }

  public void dispose() 
  {
    // Anything in here will be called automatically when the parent sketch shuts down.
    players.clear();
    tuioProcessing.dispose();
  }

  public void pre() 
  {
    // Method that's called just after beginDraw(), meaning that it can affect drawing.

    int m = millis();

    // Increase age of all players, remove those too old
    Iterator<HashMap.Entry<Long, Player>> iter = players.entrySet().iterator();
    while (iter.hasNext()) 
    {
      HashMap.Entry<Long, Player> playersEntry = iter.next();
      Player p = (Player)playersEntry.getValue();
      p.feet.clear();  
      p.age++;
      // remove if too old
      if (p.age > maxAge)
      {
          firePlayerRemoveEvent(p);
          iter.remove();
      }
    }
    
    // Update known players with available tuio data
    ArrayList<TuioCursor> tcl = tuioProcessing.getTuioCursorList();
    int i = 0;
    while (i < tcl.size())
    {
      TuioCursor tc = tcl.get(i);
      Player p = players.get(tc.getSessionID());
      if (p != null)
      {
        // update player
        p.age = 0;
        p.x = tc.getScreenX(width);
        p.y = tc.getScreenY(height - wallHeight) + wallHeight;
        tcl.remove(i);
      }
      else
      {
        i++;
      }
    }

    // check if there are new players left and handle them accordingly 
    if (tcl.size() > 0)
    {
      for (TuioCursor tc : tcl)
      {
        boolean found = false;
        // check if this was a previously known player with different id (TUIO id swap case due to jumping e.g.)
        for (HashMap.Entry<Long, Player> playersEntry : players.entrySet()) 
        {
          Player p = playersEntry.getValue();
          if (p.age == 0)
          {
            continue;
          }
          if (dist(p.x, p.y, tc.getScreenX(width), tc.getScreenY(height - wallHeight) + wallHeight) < jumpDistanceMaxTolerance * width)
          {
              // swap previous TUIO id to new id
              println("updating tuio id of player " + p.id + " from " + p.tuioId + " to " + tc.getSessionID());
              players.remove(p.tuioId);
              players.put(tc.getSessionID(), p);
              // update player
              p.age = 0;
              p.x = tc.getScreenX(width);
              p.y = tc.getScreenY(height - wallHeight) + wallHeight;
              found = true;
              break;
          }
        }
        // add as new player if nothing found
        if (!found)
        {
          Player p = new Player(this, nextUniqueID++, tc.getSessionID(), tc.getScreenX(width), tc.getScreenY(height - wallHeight) + wallHeight);
          players.put(tc.getSessionID(), p);
          firePlayerAddEvent(p);
        }
      }
    }
    
    // update the feet
    ArrayList<TuioObject> tuioObjectList = tuioProcessing.getTuioObjectList();
    ArrayList<TuioCursor> tuioCursorList = tuioProcessing.getTuioCursorList();
    for (TuioObject to : tuioObjectList)
    {
      Player p = null;
      if (to.getSymbolID() < tuioCursorList.size())
      {
        TuioCursor tc = tuioCursorList.get(to.getSymbolID());
        p = players.get(tc.getSessionID());
      }
      if (p != null)
      {
        p.feet.add(new Foot(to.getScreenX(width), to.getScreenY(height - wallHeight) + wallHeight));
      }
      else
      {
        println("unkown foot id: " + to.getSymbolID());
      } 
    }
    
  //  println((millis() - m) + " ms update");
  }

  // ------ these callback methods are called whenever a TUIO event occurs ------------------

  // called when an object is added to the scene
  void addTuioObject(TuioObject tobj) 
  {
    if (doDebug)
      println("add object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
  }

  // called when an object is removed from the scene
  void removeTuioObject(TuioObject tobj) 
  {
    if (doDebug)
      println("remove object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
  }

  // called when an object is moved
  void updateTuioObject (TuioObject tobj) 
  {
    if (doDebug)
      println("update object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()+" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
  }

  // called when a cursor is added to the scene
  void addTuioCursor(TuioCursor tcur) 
  {
    if (doDebug)
      println("add cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") "+tcur.getX()+" "+tcur.getY());
  }

  // called when a cursor is moved
  void updateTuioCursor (TuioCursor tcur) 
  {
    if (doDebug)
      println("update cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()+" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  }

  // called when a cursor is removed from the scene
  void removeTuioCursor(TuioCursor tcur) 
  {
    if (doDebug)
      println("remove cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  }

  // called after each message bundle
  // representing the end of an image frame
  void refresh(TuioTime bundleTime) 
  { 
    redraw();
  }

  void addTuioBlob(TuioBlob tblb)
  {
    if (doDebug)
      println("add blob "+tblb.getBlobID()+" ("+tblb.getSessionID()+ ") "+tblb.getX()+" "+tblb.getY());
  }

  void removeTuioBlob(TuioBlob tblb)
  {
    if (doDebug)
      println("remove blob "+tblb.getBlobID()+" ("+tblb.getSessionID()+ ") "+tblb.getX()+" "+tblb.getY());
  }

  void updateTuioBlob(TuioBlob tblb)
  {
    if (doDebug)
      println("update blob "+tblb.getBlobID()+" ("+tblb.getSessionID()+ ") "+tblb.getX()+" "+tblb.getY());
  }
}