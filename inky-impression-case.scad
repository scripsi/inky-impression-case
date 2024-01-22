// inky-impression-case.scad
//
// Copyright: Douglas Reed, September 2023
//
// This is a wall-mounting case for:
//
//   Pimoroni Inky Impression 7-colour e-ink display
//   https://shop.pimoroni.com/products/inky-impression
//
// See accompanying readme.md for full details

// The case consists of the following parts:
//
//   1 x FRAME - The front and sides of the case
//   1 x REARPANEL - The rear panel and wall-mount
//   1 x BACKPLANE - An internal panel to hold the Inky Impression in position
//   4 x BUTTON - Button extensions to allow operation of the Inky Impression's
//                buttons
//
// There is also an optional addition:
//
//   1 x STAND - A desk stand that clips into the wall-mount keyholes
//               on the rear panel

// Use the customizer in OpenScad (Menu: Window -> Customizer) to set the
// following parameters and show different parts or views of the model. Only set
// one of these to "true" at a time, and keep the others "false"!

// The frame in printable orientation.
FRAME = false;

// The backplane in printable orientation.
BACKPLANE = false;

// The rear panel in printable orientation.
REARPANEL = false;

// A button in printable orientation
BUTTON = false;

// A desk stand in printable orientation
STAND = false;

// A small cover for the IO port
IOCOVER = false;

// A front cover to protect the screen
FRONTCOVER = true;

// Show the fully assembled case
ASSEMBLED = false;

// Show an exploded view of the case
EXPLODED = false;

// The rear panel is held on by fixing bolts. Set the following parameters 
// According to the bolts you are using

// The diameter of the rear panel fixing bolts
BOLT_DIAMETER = 2.5; // M2.5 bolts

// Countersunk fixing bolts
BOLT_COUNTERSUNK = true;

// The rear panel mounts can take heat-set threaded inserts to make it easier to
// screw in the bolts. Set the following parameter to the recommended hole
// diameter for the inserts you are using (max: 6). If you don't want to
// use inserts and just want to self-tap the bolts into the plastic, set
// this to slightly less than the diameter of the bolts you are using,
// for example: 2.3 for M2.5 bolts

// Threaded insert outer diameter
INSERT_DIAMETER = 3.5;

// Other editable parameters are at the end of the file!

// *** MAIN ROUTINE ***

if (ASSEMBLED) {
  // shows the case fully assembled with Inky Impression and Raspberry Pi Zero
  // boards in position. Prefix any of the lines below with "*" to temporarily
  // remove that element and see inside the case
  frame();
  rearpanel();
  backplane();
  buttons();
  stand();
  inky();
  rpizero();
  powerboard();
  usbboard();
  ioconnector();
  iocover();
  frontcover();
} else
if (EXPLODED) {
  rotate([-stand_angle,0,0]) {
    translate([0,-50,0]) frame();
    translate([0,130,0]) rearpanel();
    translate([0,150,0]) stand();
    translate([0,50,0]) backplane();
    translate([-50,-50,0]) buttons();
    inky();
    translate([0,80,0]) rpizero();
    translate([0,80,0]) powerboard();
    translate([0,80,0]) usbboard();
    translate([0,80,0]) ioconnector();
    translate([0,-50,20]) iocover();
    translate([0,-80,00]) frontcover();
  }
} else {
  // shows case parts in the correct orientation for printing
  if (FRAME) { rotate([90,0,0]) frame(); }
  if (REARPANEL) { rotate([-90,0,0]) rearpanel(); }
  if (BACKPLANE) { rotate([90,0,0]) backplane(); }
  if (BUTTON) { rotate([90,0,0]) button(0); }
  if (STAND) { rotate([-stand_angle,0,0]) stand(); }
  if (IOCOVER) { rotate([180,0,0]) iocover(); }
  if (FRONTCOVER) { rotate([90,0,0]) frontcover(); }
}


// *** MODULES ***

module frame() {
  // The front and sides of the case
  difference() {
    union() { // union of solids
      translate([frame_offset_w,frame_offset_d,frame_offset_h])
        color("SlateGray") cube([frame_w,frame_d,frame_h]);
    } // union of solids
    
    union() { // union of holes
      // screen cutout
      translate([inky_screen_offset_w, frame_offset_d - a_bit, inky_screen_offset_h])
        cube([inky_screen_w, frame_thickness_front + a_bit_more, inky_screen_h]);
      // inky board cutout
      translate([-frame_clearance_w, frame_offset_d + frame_thickness_front, -inky_screen_cable_h - frame_clearance_h])
        cube([inky_board_w + frame_clearance_w * 2, frame_d, inky_board_h+inky_screen_cable_h + frame_clearance_h]);
      // backplane ledge cutout
      translate([frame_offset_w + frame_thickness_sides, backplane_offset_d, frame_offset_h+frame_thickness_sides])
        cube([frame_w - (frame_thickness_sides * 2), frame_d, frame_h - (frame_thickness_sides * 2)]);

      // inky connector cutout
      //translate([inky_conn_offset_w, inky_board_d, frame_offset_h - a_bit])
      //  cube([inky_conn_w, frame_d, frame_thickness_sides + a_bit_more]);
        
      // power connector cutout
      translate([powerboard_offset_w+((powerboard_w-powerboard_socket_w)/2-powerboard_socket_clearance), powerboard_offset_d+powerboard_d-powerboard_socket_clearance, frame_offset_h - a_bit])
        cube([powerboard_socket_w + powerboard_socket_clearance * 2, frame_d, frame_thickness_sides + a_bit_more]);
        
      // USB connector cutout
      translate([usbboard_offset_w+((usbboard_w-usbboard_socket_w)/2-usbboard_socket_clearance), usbboard_offset_d+usbboard_d-usbboard_socket_clearance, frame_offset_h - a_bit])
        cube([usbboard_socket_w + usbboard_socket_clearance * 2, frame_d, frame_thickness_sides + a_bit_more]);
        
      // IO connector cutout
      translate([io_offset_w, backplane_offset_d+backplane_d, backplane_offset_h + backplane_h - a_bit])
        difference(){
          cube([io_w, frame_d, frame_thickness_sides + a_bit_more]);
            
          union(){
            translate([io_w,0,0]) cylinder(h=frame_d+a_bit_more*2,r=io_w/3);
            translate([0,io_d/2,0]) cylinder(h=frame_d+a_bit_more*2,r=io_w/3);
            translate([io_w,io_d,0]) cylinder(h=frame_d+a_bit_more*2,r=io_w/3);
            translate([0,io_d,0]) cube([io_w,io_h,frame_d+a_bit_more*2]);
          }// union()
      } // difference()
      
      // mount holes
      translate([rearpanel_offset_w, rearpanel_offset_d - rearpanel_mount_d, frame_offset_h]) {
        translate([rearpanel_mount_r,rearpanel_mount_d-rearpanel_mount_r+rearpanel_d,-a_bit]) bolt(radius=rearpanel_mount_bolt_r + rearpanel_mount_bolt_clearance,length=rearpanel_mount_bolt_length);
      }
      translate([rearpanel_offset_w + rearpanel_w - rearpanel_mount_w, rearpanel_offset_d - rearpanel_mount_d, frame_offset_h]) {
        translate([rearpanel_mount_w-rearpanel_mount_r,rearpanel_mount_d-rearpanel_mount_r+rearpanel_d,-a_bit]) bolt(radius=rearpanel_mount_bolt_r + rearpanel_mount_bolt_clearance,length=rearpanel_mount_bolt_length);
      }
      translate([rearpanel_offset_w + rearpanel_w - rearpanel_mount_w, rearpanel_offset_d - rearpanel_mount_d, frame_offset_h + frame_h]) {
        translate([rearpanel_mount_w-rearpanel_mount_r,rearpanel_mount_d-rearpanel_mount_r+rearpanel_d,a_bit]) rotate([180,0,0]) bolt(radius=rearpanel_mount_bolt_r + rearpanel_mount_bolt_clearance,length=rearpanel_mount_bolt_length);
      }
      translate([rearpanel_offset_w, rearpanel_offset_d - rearpanel_mount_d, frame_offset_h + frame_h]) {
        translate([rearpanel_mount_r,rearpanel_mount_d-rearpanel_mount_r+rearpanel_d,a_bit]) rotate([180,0,0]) bolt(radius=rearpanel_mount_bolt_r + rearpanel_mount_bolt_clearance,length=rearpanel_mount_bolt_length);
      }
      
      // vent holes
      for(i=[2,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18]) {
        translate([frame_offset_w + (frame_w/20)*i,frame_d-rearpanel_d-rearpanel_mount_r,frame_offset_h+frame_h-frame_thickness_sides-a_bit])
          cylinder(h=frame_thickness_sides+a_bit_more, r=frame_vent_hole_r);
      } // for()
      for(i=[2,3,8,12,13,14,15,16,17,18]) {
        translate([frame_offset_w + (frame_w/20)*i,frame_d-rearpanel_d-rearpanel_mount_r,frame_offset_h-a_bit])
          cylinder(h=frame_thickness_sides+a_bit_more, r=frame_vent_hole_r);
      } // for()
      
      // buttons
      translate([-frame_border - a_bit, inky_board_d, inky_btn_a_offset_h - button_clearance])
        cube([frame_border + a_bit_more, button_d + button_clearance * 2 , button_h + button_clearance * 2]);
      translate([-frame_border - a_bit, inky_board_d, inky_btn_b_offset_h - button_clearance])
        cube([frame_border + a_bit_more, button_d + button_clearance * 2 , button_h + button_clearance * 2]);
      translate([-frame_border - a_bit, inky_board_d, inky_btn_c_offset_h - button_clearance])
        cube([frame_border + a_bit_more, button_d + button_clearance * 2 , button_h + button_clearance * 2]);
      translate([-frame_border - a_bit, inky_board_d, inky_btn_d_offset_h - button_clearance])
        cube([frame_border + a_bit_more, button_d + button_clearance * 2 , button_h + button_clearance * 2]);
    } // union of holes
  }
} // module frame()

module backplane() {
  // Backplane to support the Inky Impression and hold it
  // in the right position within the case
  
  difference(){
    color("SlateGray") union() { //union of solids
      // backplane
      translate([backplane_offset_w,backplane_offset_d,backplane_offset_h])
        cube([backplane_w,backplane_d,backplane_h]);
      // Mounting risers
      translate([inky_mount_a_offset_w,inky_board_d+inky_mount_d,inky_mount_a_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_d + backplane_mount_riser_d, r=backplane_mount_riser_r);
      translate([inky_mount_b_offset_w,inky_board_d+inky_mount_d,inky_mount_b_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_d + backplane_mount_riser_d, r=backplane_mount_riser_r);
      translate([inky_mount_c_offset_w,inky_board_d+inky_mount_d,inky_mount_c_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_d + backplane_mount_riser_d, r=backplane_mount_riser_r);
      translate([inky_mount_d_offset_w,inky_board_d+inky_mount_d,inky_mount_d_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_d + backplane_mount_riser_d, r=backplane_mount_riser_r);
      // Powerboard mounts
      translate([backplane_powerboard_mount_a_offset_w,backplane_offset_d+backplane_d,backplane_powerboard_mount_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_powerboard_mount_d, r=backplane_powerboard_mount_r);
      translate([backplane_powerboard_mount_b_offset_w,backplane_offset_d+backplane_d,backplane_powerboard_mount_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_powerboard_mount_d, r=backplane_powerboard_mount_r);
      // USBboard mounts
      translate([backplane_usbboard_mount_a_offset_w,backplane_offset_d+backplane_d,backplane_usbboard_mount_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_usbboard_mount_d, r=backplane_usbboard_mount_r);
      translate([backplane_usbboard_mount_b_offset_w,backplane_offset_d+backplane_d,backplane_usbboard_mount_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_usbboard_mount_d, r=backplane_usbboard_mount_r);
      // IO connector supports
      translate([io_offset_w - io_support_w - io_support_clearance, backplane_offset_d + backplane_d, io_offset_h])
        cube([io_support_w,io_support_d,io_h]);
      translate([io_offset_w + io_w + io_support_clearance, backplane_offset_d + backplane_d, io_offset_h])
        cube([io_support_w,io_support_d,io_h]);
      translate([io_offset_w + io_w - io_cutout_w + io_support_clearance, backplane_offset_d + backplane_d, io_offset_h + io_cutout_offset_h])
        cube([io_cutout_w,io_support_d,io_cutout_h]);
      translate([io_offset_w - io_support_clearance, backplane_offset_d + backplane_d, io_offset_h + io_cutout_offset_h])
        cube([io_cutout_w,io_support_d,io_cutout_h]);
    } // union of solids
    
    union() { // union of holes
      
      // mounting holes
      translate([inky_mount_a_offset_w,inky_board_d+inky_mount_d-a_bit,inky_mount_a_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_d+backplane_mount_riser_d+a_bit_more, r=backplane_mount_hole_r);
      translate([inky_mount_b_offset_w,inky_board_d+inky_mount_d-a_bit,inky_mount_b_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_d+backplane_mount_riser_d+a_bit_more, r=backplane_mount_hole_r);
      translate([inky_mount_c_offset_w,inky_board_d+inky_mount_d-a_bit,inky_mount_c_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_d+backplane_mount_riser_d+a_bit_more, r=backplane_mount_hole_r);
      translate([inky_mount_d_offset_w,inky_board_d+inky_mount_d-a_bit,inky_mount_d_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_d+backplane_mount_riser_d+a_bit_more, r=backplane_mount_hole_r);
      
      translate([backplane_powerboard_mount_a_offset_w,backplane_offset_d-a_bit,backplane_powerboard_mount_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_powerboard_mount_d + backplane_d + a_bit_more, r=backplane_powerboard_mount_hole_r);
      translate([backplane_powerboard_mount_b_offset_w,backplane_offset_d-a_bit,backplane_powerboard_mount_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_powerboard_mount_d + backplane_d + a_bit_more, r=backplane_powerboard_mount_hole_r);
        
      translate([backplane_usbboard_mount_a_offset_w,backplane_offset_d-a_bit,backplane_usbboard_mount_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_usbboard_mount_d + backplane_d + a_bit_more, r=backplane_usbboard_mount_hole_r);
      translate([backplane_usbboard_mount_b_offset_w,backplane_offset_d-a_bit,backplane_usbboard_mount_offset_h])
        rotate([-90,0,0]) cylinder(h=backplane_usbboard_mount_d + backplane_d + a_bit_more, r=backplane_usbboard_mount_hole_r);
      
      // button cutouts
      translate([inky_btn_offset_w - backplane_clearance, inky_board_d + inky_mount_d - a_bit, inky_btn_a_offset_h - backplane_clearance]) {
        cube([inky_btn_w + backplane_clearance * 2,backplane_d + a_bit_more, inky_btn_h + backplane_clearance * 2]);
        translate([a_bit-button_w,0,inky_btn_h/2-inky_btn_striker_h/2])
          cube([button_w, backplane_d + a_bit_more, inky_btn_striker_h + backplane_clearance * 2]);
      }
      translate([inky_btn_offset_w - backplane_clearance, inky_board_d + inky_mount_d - a_bit, inky_btn_b_offset_h - backplane_clearance]) {
        cube([inky_btn_w + backplane_clearance * 2,backplane_d + a_bit_more, inky_btn_h + backplane_clearance * 2]);
        translate([a_bit-button_w,0,inky_btn_h/2-inky_btn_striker_h/2])
          cube([button_w, backplane_d + a_bit_more, inky_btn_striker_h + backplane_clearance * 2]);
      }
      translate([inky_btn_offset_w - backplane_clearance, inky_board_d + inky_mount_d - a_bit, inky_btn_c_offset_h - backplane_clearance]) {
        cube([inky_btn_w + backplane_clearance * 2,backplane_d + a_bit_more, inky_btn_h + backplane_clearance * 2]);
        translate([a_bit-button_w,0,inky_btn_h/2-inky_btn_striker_h/2])
          cube([button_w, backplane_d + a_bit_more, inky_btn_striker_h + backplane_clearance * 2]);
      }
      translate([inky_btn_offset_w - backplane_clearance, inky_board_d + inky_mount_d - a_bit, inky_btn_d_offset_h - backplane_clearance]) {
        cube([inky_btn_w + backplane_clearance * 2,backplane_d + a_bit_more, inky_btn_h + backplane_clearance * 2]);
        translate([a_bit-button_w,0,inky_btn_h/2-inky_btn_striker_h/2])
          cube([button_w, backplane_d + a_bit_more, inky_btn_striker_h + backplane_clearance * 2]);
      }
      
      // pi header cutout
      translate([inky_hdr_offset_w-backplane_clearance,inky_board_d+inky_mount_d-a_bit,inky_hdr_offset_h-backplane_clearance])
        cube([inky_hdr_w+backplane_clearance*2,backplane_d+a_bit_more,inky_hdr_h+backplane_clearance*2]);
      // breakout connector cutout
      translate([inky_conn_offset_w-backplane_clearance,inky_board_d+inky_mount_d-a_bit,-inky_conn_offset_h])
        cube([inky_conn_w+backplane_clearance*2,inky_board_d+a_bit_more,inky_conn_offset_h+inky_conn_h*2.5+a_bit]);
    } // union of holes
  } // difference()
} // module backplane()

module buttons() {
  color("red") button(inky_btn_a_offset_h); 
  color("yellow") button(inky_btn_b_offset_h);
  color("green") button(inky_btn_c_offset_h);
  color("blue") button(inky_btn_d_offset_h);
} // module buttons()

module button(offset_h) {
  translate([button_offset_w, inky_board_d, offset_h])
    union() {  
      cube([button_w, button_d, button_h]);
      translate([0,0,button_h/2]) rotate([-90,0,0]) cylinder(h=button_d, r=button_h/2);
      translate([button_lug_offset_w,button_lug_offset_d,button_lug_offset_h]) cube([button_lug_w,button_lug_d,button_lug_h]);
    }
} // module button(offset_h)

module rearpanel() {
  difference() {
    color("LightSlateGray") union() { // union of solids
      // panel
      translate([rearpanel_offset_w, rearpanel_offset_d, rearpanel_offset_h])
        cube([rearpanel_w, rearpanel_d, rearpanel_h]);
      
      // mounts
      translate([rearpanel_offset_w, rearpanel_offset_d - rearpanel_mount_d, rearpanel_offset_h]) {
        cube([rearpanel_mount_w, rearpanel_mount_d, rearpanel_mount_h]);
        translate([rearpanel_mount_r,rearpanel_mount_d-rearpanel_mount_r+rearpanel_d,0]) cylinder(h=rearpanel_mount_h, r=rearpanel_mount_r);
      }
      translate([rearpanel_offset_w + rearpanel_w - rearpanel_mount_w, rearpanel_offset_d - rearpanel_mount_d, rearpanel_offset_h]) {
        cube([rearpanel_mount_w, rearpanel_mount_d, rearpanel_mount_h]);
        translate([rearpanel_mount_w-rearpanel_mount_r,rearpanel_mount_d-rearpanel_mount_r+rearpanel_d,0]) cylinder(h=rearpanel_mount_h, r=rearpanel_mount_r);
      }
      translate([rearpanel_offset_w + rearpanel_w - rearpanel_mount_w, rearpanel_offset_d - rearpanel_mount_d, rearpanel_offset_h + rearpanel_h - rearpanel_mount_h]) {
        cube([rearpanel_mount_w, rearpanel_mount_d, rearpanel_mount_h]);
        translate([rearpanel_mount_w-rearpanel_mount_r,rearpanel_mount_d-rearpanel_mount_r+rearpanel_d,0]) cylinder(h=rearpanel_mount_h, r=rearpanel_mount_r);
      }
      translate([rearpanel_offset_w, rearpanel_offset_d - rearpanel_mount_d,  rearpanel_offset_h + rearpanel_h - rearpanel_mount_h]) {
        cube([rearpanel_mount_w, rearpanel_mount_d, rearpanel_mount_h]);
        translate([rearpanel_mount_r,rearpanel_mount_d-rearpanel_mount_r+rearpanel_d,0]) cylinder(h=rearpanel_mount_h, r=rearpanel_mount_r);
      }
    } // union of solids
    
    union() { //union of holes
      // mounting bolt holes
      translate([rearpanel_offset_w, rearpanel_offset_d - rearpanel_mount_d, rearpanel_offset_h]) {
        translate([rearpanel_mount_r,rearpanel_mount_d-rearpanel_mount_r+rearpanel_d,-a_bit]) cylinder(h=rearpanel_mount_h+a_bit_more, r=rearpanel_mount_insert_r);
      }
      translate([rearpanel_offset_w + rearpanel_w - rearpanel_mount_w, rearpanel_offset_d - rearpanel_mount_d, rearpanel_offset_h]) {
        translate([rearpanel_mount_w-rearpanel_mount_r,rearpanel_mount_d-rearpanel_mount_r+rearpanel_d,-a_bit]) cylinder(h=rearpanel_mount_h+a_bit_more, r=rearpanel_mount_insert_r);
      }
      translate([rearpanel_offset_w + rearpanel_w - rearpanel_mount_w, rearpanel_offset_d - rearpanel_mount_d, rearpanel_offset_h + rearpanel_h - rearpanel_mount_h]) {
        translate([rearpanel_mount_w-rearpanel_mount_r,rearpanel_mount_d-rearpanel_mount_r+rearpanel_d,-a_bit]) cylinder(h=rearpanel_mount_h+a_bit_more, r=rearpanel_mount_insert_r);
      }
      translate([rearpanel_offset_w, rearpanel_offset_d - rearpanel_mount_d,  rearpanel_offset_h + rearpanel_h - rearpanel_mount_h]) {
        translate([rearpanel_mount_r,rearpanel_mount_d-rearpanel_mount_r+rearpanel_d,-a_bit]) cylinder(h=rearpanel_mount_h+a_bit_more, r=rearpanel_mount_insert_r);
      }
      
      // keyholes for wall-mounting
      key1_offset_w = rearpanel_key_spacing_w / 2;
      key2_offset_w = -rearpanel_key_spacing_w / 2;
      
      translate([rearpanel_offset_w + rearpanel_w / 2 + key1_offset_w, rearpanel_offset_d - a_bit, rearpanel_offset_h + rearpanel_h / 2])
        union() { 
          translate([0, 0, 0]) rotate([-90,0,0]) cylinder(h=rearpanel_d + a_bit_more, r=rearpanel_key_slot_r);
          translate([0, 0, -rearpanel_key_slot_h]) rotate([-90,0,0]) cylinder(h=rearpanel_d + a_bit_more, r=rearpanel_key_hole_r);
          translate([-rearpanel_key_slot_r, 0, -rearpanel_key_slot_h]) cube([rearpanel_key_slot_r * 2,rearpanel_d + a_bit_more,rearpanel_key_slot_h]);
        }

      translate([rearpanel_offset_w + rearpanel_w / 2 + key2_offset_w, rearpanel_offset_d - a_bit, rearpanel_offset_h + rearpanel_h / 2])
        union() { 
          translate([0, 0, 0]) rotate([-90,0,0]) cylinder(h=rearpanel_d + a_bit_more, r=rearpanel_key_slot_r);
          translate([0, 0, -rearpanel_key_slot_h]) rotate([-90,0,0]) cylinder(h=rearpanel_d + a_bit_more, r=rearpanel_key_hole_r);
          translate([-rearpanel_key_slot_r, 0, -rearpanel_key_slot_h]) cube([rearpanel_key_slot_r * 2,rearpanel_d + a_bit_more,rearpanel_key_slot_h]);
        }
    } // union of holes
  } // difference()
} // module rearpanel()

module stand() {
  difference() {
    color("LightGray") union() { // union of solids
      // leg1
      translate([stand_leg1_offset_w-stand_leg_r,stand_offset_d,stand_offset_h])
        union() {
          cube([stand_leg_w,stand_leg_r,stand_leg_h]);
          translate([stand_leg_r,stand_leg_r,0]) cylinder(r=stand_leg_r,h=stand_leg_h);
        }
      translate([stand_leg1_offset_w-stand_leg_r,stand_offset_d,stand_offset_h])  
        rotate([-90+stand_angle,0,0])
        union() {
          cube([stand_leg_w,stand_leg_r,stand_leg_d]);
          translate([stand_leg_r,0,stand_leg_r]) cylinder(r=stand_leg_r,h=stand_leg_d-stand_leg_r);
        }
      // peg1
      translate([stand_leg1_offset_w,stand_offset_d,stand_peg_offset_h+stand_peg_stem_r])  
        rotate([90,0,0])
        union() {
          cylinder(r=stand_peg_stem_r,h=stand_peg_stem_d);
          hull(){
            translate([0,0,stand_peg_stem_d]) cylinder(r=stand_peg_stem_r,h=stand_peg_flange_d);
            translate([0,stand_peg_flange_r,stand_peg_stem_d]) cylinder(r=stand_peg_flange_r,h=stand_peg_flange_d);
          }  
        }
      // leg2
      translate([stand_leg2_offset_w-stand_leg_r,stand_offset_d,stand_offset_h])
        union() {
          cube([stand_leg_w,stand_leg_r,stand_leg_h]);
          translate([stand_leg_r,stand_leg_r,0]) cylinder(r=stand_leg_r,h=stand_leg_h);
        }
      translate([stand_leg2_offset_w-stand_leg_r,stand_offset_d,stand_offset_h])  
        rotate([-90+stand_angle,0,0])
        union() {
          cube([stand_leg_w,stand_leg_r,stand_leg_d]);
          translate([stand_leg_r,0,stand_leg_r]) cylinder(r=stand_leg_r,h=stand_leg_d-stand_leg_r);
        }
      // peg2
      translate([stand_leg2_offset_w,stand_offset_d,stand_peg_offset_h+stand_peg_stem_r])  
        rotate([90,0,0])
        union() {
          cylinder(r=stand_peg_stem_r,h=stand_peg_stem_d);
          hull(){
            translate([0,0,stand_peg_stem_d]) cylinder(r=stand_peg_stem_r,h=stand_peg_flange_d);
            translate([0,stand_peg_flange_r,stand_peg_stem_d]) cylinder(r=stand_peg_flange_r,h=stand_peg_flange_d);
          }  
        }
      //rear crossbar
      translate([stand_crossbar_offset_w,stand_offset_d,stand_offset_h])  
        rotate([-90+stand_angle,0,0])
        translate([0,0,stand_leg_d-stand_crossbar_d]) union() {
          cube([stand_crossbar_w,stand_crossbar_r,stand_crossbar_d]);
          translate([0,stand_crossbar_r,0]) rotate([0,90,0]) cylinder(r=stand_crossbar_r,h=stand_crossbar_w);
        }
       //front crossbar
      translate([stand_crossbar_offset_w,stand_offset_d,stand_offset_h])  
        rotate([-90+stand_angle,0,0])
        translate([0,0,-stand_crossbar_d]) union() {
          cube([stand_crossbar_w,stand_crossbar_r,stand_crossbar_d]);
          translate([0,stand_crossbar_r,0]) rotate([0,90,0]) cylinder(r=stand_crossbar_r,h=stand_crossbar_w);
        }  
    } // union of solids
    union() { // union of holes
      // shave pegs
      translate([stand_leg1_offset_w,stand_offset_d,stand_peg_offset_h])  
        rotate([stand_angle * 2,0,0])
          translate([-stand_leg_w/2,-stand_leg_w,0]) cube([stand_leg_w,stand_leg_w,stand_peg_flange_r*2]);
      translate([stand_leg2_offset_w,stand_offset_d,stand_peg_offset_h])  
        rotate([stand_angle * 2,0,0])
          translate([-stand_leg_w/2,-stand_leg_w,0]) cube([stand_leg_w,stand_leg_w,stand_peg_flange_r*2]);
      // cut off base of rear crossbar
      // crossbar
      translate([stand_crossbar_offset_w,stand_offset_d,stand_offset_h])  
        rotate([-90+stand_angle,0,0])
        translate([0,0,stand_leg_d-stand_crossbar_d]) union() {
          translate([-a_bit,stand_crossbar_r,-stand_crossbar_r]) cube([stand_crossbar_w+a_bit_more,stand_crossbar_r,stand_crossbar_d]);
        }
      // cut off base and middle of front crossbar
      // crossbar
      translate([stand_crossbar_offset_w,stand_offset_d,stand_offset_h])  
        rotate([-90+stand_angle,0,0])
        translate([0,0,-stand_crossbar_d]) union() {
          translate([-a_bit,stand_crossbar_r,-stand_crossbar_r]) cube([stand_crossbar_w+a_bit_more,stand_crossbar_r,stand_crossbar_d]);
          translate([stand_leg_w,-a_bit,-stand_crossbar_r-a_bit]) cube([stand_crossbar_w-(stand_leg_w*2),stand_crossbar_r+a_bit_more,stand_crossbar_d+stand_crossbar_r+a_bit_more]);
        }
    } // union of holes
  } // difference()
} // module stand()

module rpizero() {
  // Crude Raspberry Pi Zero model to check for fit
  translate([rpizero_offset_w, rpizero_offset_d, rpizero_offset_h])
    color("Green") cube([rpizero_w, rpizero_d, rpizero_h]);
} // module rpizero()

module ioconnector() {
  // Crude io connector model to check for fit
  difference(){ // union of solids
    union() {
      translate([io_offset_w, io_offset_d, io_offset_h])
        color("Black") cube([io_w, io_d, io_h]);
    } // union of solids
    
    union() { // union of holes
      translate([io_offset_w-a_bit, io_offset_d-a_bit, io_offset_h + io_cutout_offset_h])
        cube([io_cutout_w+a_bit, io_d+a_bit_more, io_cutout_h]);
      translate([io_offset_w+io_w-io_cutout_w, io_offset_d-a_bit, io_offset_h + io_cutout_offset_h])
        cube([io_cutout_w+a_bit, io_d+a_bit_more, io_cutout_h]);
    } // union of holes
  } //difference
} // module ioconnector()

module powerboard() {
  // Crude model of power board to check for fit
  
  difference(){ // union of solids
    union() {
      translate([powerboard_offset_w, powerboard_offset_d, powerboard_offset_h])
        color("SteelBlue") cube([powerboard_w, powerboard_d, powerboard_h]);
      translate([powerboard_offset_w+((powerboard_w-powerboard_socket_w)/2), powerboard_offset_d+powerboard_d, powerboard_offset_h+powerboard_socket_offset_h])
        color("Silver") cube([powerboard_socket_w, powerboard_socket_d, powerboard_socket_h]);
    } // union of solids
    
    union() { // union of holes
      translate([powerboard_offset_w+powerboard_hole_offset_w, powerboard_offset_d - a_bit, powerboard_offset_h+powerboard_hole_offset_h])
        rotate([-90,0,0]) cylinder(h=powerboard_d+a_bit_more, r=powerboard_hole_r);
      translate([powerboard_offset_w+powerboard_w-powerboard_hole_offset_w, powerboard_offset_d - a_bit, powerboard_offset_h+powerboard_hole_offset_h])
        rotate([-90,0,0]) cylinder(h=powerboard_d+a_bit_more, r=powerboard_hole_r);
    } // union of holes
  } //difference
} // module powerboard()

module usbboard() {
  // Crude model of USB board to check for fit
  
  difference(){ // union of solids
    union() {
      translate([usbboard_offset_w, usbboard_offset_d, usbboard_offset_h])
        color("SteelBlue") cube([usbboard_w, usbboard_d, usbboard_h]);
      translate([usbboard_offset_w+((usbboard_w-usbboard_socket_w)/2), usbboard_offset_d+usbboard_d, usbboard_offset_h+usbboard_socket_offset_h])
        color("Silver") cube([usbboard_socket_w, usbboard_socket_d, usbboard_socket_h]);
      translate([usbboard_offset_w+((usbboard_w-usbboard_stick_w)/2), usbboard_offset_d+usbboard_d+usbboard_stick_offset_d, usbboard_offset_h+usbboard_stick_offset_h])
        color("Black") cube([usbboard_stick_w, usbboard_stick_d, usbboard_stick_h]);
    } // union of solids
    
    union() { // union of holes
      translate([usbboard_offset_w+usbboard_hole_offset_w, usbboard_offset_d - a_bit, usbboard_offset_h+usbboard_hole_offset_h])
        rotate([-90,0,0]) cylinder(h=usbboard_d+a_bit_more, r=usbboard_hole_r);
      translate([usbboard_offset_w+usbboard_w-usbboard_hole_offset_w, usbboard_offset_d - a_bit, usbboard_offset_h+usbboard_hole_offset_h])
        rotate([-90,0,0]) cylinder(h=usbboard_d+a_bit_more, r=usbboard_hole_r);
    } // union of holes
  } //difference
} // module powerboard()

module iocover() {
  color("SlateGray") translate([io_offset_w, backplane_offset_d+backplane_d, backplane_offset_h + backplane_h + a_bit_more])
        difference(){
          translate([io_cover_clearance,io_cover_clearance,0]) cube([io_w-io_cover_clearance*2, io_d-io_cover_clearance*2, frame_thickness_sides]);
            
          union(){
            translate([io_w,0,-a_bit]) cylinder(h=frame_thickness_sides+a_bit_more,r=io_w/3+io_cover_clearance);
            translate([0,io_d/2,-a_bit]) cylinder(h=frame_thickness_sides+a_bit_more,r=io_w/3+io_cover_clearance);
            translate([io_w,io_d,-a_bit]) cylinder(h=frame_thickness_sides+a_bit_more,r=io_w/3+io_cover_clearance);
            //translate([0,io_d,0]) cube([io_w,io_h,frame_d+a_bit_more*2]);
              
            // LED holes
            translate([(io_w/2)+(io_cover_hole_pitch/2),(io_d/2)-(io_cover_hole_pitch/2),-a_bit])
              cylinder(h=frame_thickness_sides+a_bit_more,r=io_cover_hole_r);
            translate([(io_w/2)+(io_cover_hole_pitch/2),(io_d/2)+(io_cover_hole_pitch/2),-a_bit])
              cylinder(h=frame_thickness_sides+a_bit_more,r=io_cover_hole_r);
          }// union()
      } // difference()   
}

module frontcover() {
  difference() {
    color("Red") translate([cover_offset_w, cover_offset_d, cover_offset_h])
      cube([cover_w, cover_d, cover_h]);
    
    translate([cover_offset_w + cover_thickness_sides - cover_clearance, cover_offset_d + cover_thickness_front, cover_offset_h + cover_thickness_sides - cover_clearance])
      cube([cover_w - cover_thickness_sides * 2 + cover_clearance * 2, cover_d, cover_h - cover_thickness_sides * 2 + cover_clearance * 2]);
  } // difference()
  
  // spacers
  color("Red") {
    translate([cover_offset_w, cover_offset_d + cover_thickness_front, cover_offset_h + cover_h - cover_thickness_sides - cover_spacer_width])
      cube([cover_w,cover_spacer_d,cover_spacer_width + cover_thickness_sides]);
    translate([cover_offset_w, cover_offset_d + cover_thickness_front, cover_offset_h])
      cube([cover_spacer_width + cover_thickness_sides,cover_spacer_d,cover_h]);
    translate([cover_offset_w + cover_w - cover_thickness_sides - cover_spacer_width + cover_clearance, cover_offset_d + cover_thickness_front, cover_offset_h])
      cube([cover_spacer_width,cover_spacer_d,cover_h]);
    
      difference() {
        translate([cover_offset_w, cover_offset_d, cover_offset_h])
          cube([cover_w,cover_spacer_d + cover_thickness_front,stand_crossbar_d+stand_crossbar_r+cover_spacer_width + cover_clearance * 2 + cover_thickness_sides]);
        
        union() { //union() of holes
           translate([stand_crossbar_offset_w - cover_clearance, cover_offset_d + cover_thickness_front, cover_offset_h + cover_thickness_sides])
             cube([stand_crossbar_w + cover_clearance * 2, cover_spacer_d + a_bit_more, stand_crossbar_d + stand_crossbar_r + cover_clearance * 2]);
            
           translate([stand_leg1_offset_w - stand_leg_r - cover_clearance, cover_offset_d + cover_thickness_front, cover_offset_h + cover_thickness_sides])
             cube([stand_leg_w + cover_clearance * 2, cover_spacer_d + a_bit_more, stand_crossbar_d *2]);
          translate([stand_leg2_offset_w - stand_leg_r - cover_clearance, cover_offset_d + cover_thickness_front, cover_offset_h + cover_thickness_sides])
             cube([stand_leg_w + cover_clearance * 2, cover_spacer_d + a_bit_more, stand_crossbar_d *2]);
        } //union() of holes
      } // difference()
  }
  
} // module frontcover()

module inky() {
  // Model of the Inky Impression to test fit within the case
  
  // mainboard
  color("DarkSlateGray") cube([inky_board_w, inky_board_d, inky_board_h]);
  
  // active area of screen
  translate([inky_screen_offset_w,-a_bit,inky_screen_offset_h])
    color("White") cube([inky_screen_w,a_bit_more,inky_screen_h]);
  
  // coloured text on screen - just a bit of fun!
  t = ["D","E","P","L","O","Y","R","A","I","N","B","O","W","S"];
  c = ["red","darkorange","gold","greenyellow","dodgerblue"];
  
  translate([inky_screen_offset_w,0.4,inky_screen_offset_h]) 
  rotate([90,0,0])
  union() {     
    for (x = [0:11]) {
      for (y = [8:-1:0]) {
        tpos = (x+(y*11)) % 14;
        cpos = (x+(y*11)) % 5;
        translate([x*10,y*10]) color(c[cpos]) text(t[tpos],size = 6,font="Liberation Mono:style=Bold",valign = "bottom");
      }
    }
  }
        
  // buttons
  translate([inky_btn_offset_w,inky_board_d,inky_btn_a_offset_h])
    union() {
      color("Ivory") cube([inky_btn_w,inky_btn_d,inky_btn_h]);
      translate([-inky_btn_striker_w,inky_btn_d/2-inky_btn_striker_d/2,inky_btn_h/2-inky_btn_striker_h/2])
        color("Black") cube([inky_btn_striker_w,inky_btn_striker_d,inky_btn_striker_h]);
    }
  translate([inky_btn_offset_w,inky_board_d,inky_btn_b_offset_h])
    union() {
      color("Ivory") cube([inky_btn_w,inky_btn_d,inky_btn_h]);
      translate([-inky_btn_striker_w,inky_btn_d/2-inky_btn_striker_d/2,inky_btn_h/2-inky_btn_striker_h/2])
        color("Black") cube([inky_btn_striker_w,inky_btn_striker_d,inky_btn_striker_h]);
    }
  translate([inky_btn_offset_w,inky_board_d,inky_btn_c_offset_h])
    union() {
      color("Ivory") cube([inky_btn_w,inky_btn_d,inky_btn_h]);
      translate([-inky_btn_striker_w,inky_btn_d/2-inky_btn_striker_d/2,inky_btn_h/2-inky_btn_striker_h/2])
        color("Black") cube([inky_btn_striker_w,inky_btn_striker_d,inky_btn_striker_h]);
    }
  translate([inky_btn_offset_w,inky_board_d,inky_btn_d_offset_h])
    union() {
      color("Ivory") cube([inky_btn_w,inky_btn_d,inky_btn_h]);
      translate([-inky_btn_striker_w,inky_btn_d/2-inky_btn_striker_d/2,inky_btn_h/2-inky_btn_striker_h/2])
        color("Black") cube([inky_btn_striker_w,inky_btn_striker_d,inky_btn_striker_h]);
    }
  
  // mounts
  color("silver") {
  translate([inky_mount_a_offset_w,inky_board_d,inky_mount_a_offset_h])
    rotate([-90,0,0]) cylinder(h=inky_mount_d, r=inky_mount_outer_r);
  translate([inky_mount_b_offset_w,inky_board_d,inky_mount_b_offset_h])
    rotate([-90,0,0]) cylinder(h=inky_mount_d, r=inky_mount_outer_r);  
  translate([inky_mount_c_offset_w,inky_board_d,inky_mount_c_offset_h])
    rotate([-90,0,0]) cylinder(h=inky_mount_d, r=inky_mount_outer_r);  
  translate([inky_mount_d_offset_w,inky_board_d,inky_mount_d_offset_h])
    rotate([-90,0,0]) cylinder(h=inky_mount_d, r=inky_mount_outer_r);
  }  
    
  // pi header
  translate([inky_hdr_offset_w,inky_board_d,inky_hdr_offset_h])
    color("Black") cube([inky_hdr_w,inky_hdr_d,inky_hdr_h]);
    
  // breakout connector
  translate([inky_conn_offset_w,inky_board_d,inky_conn_offset_h])
    color("Black") cube([inky_conn_w,inky_conn_d,inky_conn_h]);
   
  // screen cable
  translate([inky_board_w/2-inky_screen_cable_w/2,0,-inky_screen_cable_h])
    color("Goldenrod") cube([inky_screen_cable_w,inky_board_d,inky_screen_cable_h]); 
    
} // module inky()

module bolt(radius,length) {
	h1=0.6*radius*2;
	h2=length-h1;
	cylinder(r=radius,h=length);
  if (BOLT_COUNTERSUNK) {	cylinder(r1=radius*2,r2=radius,h=h1); }
} // module bolt()


// *** PARAMETERS ***

// Conventions:
//
// origin = [0,0,0] = bottom, left, front corner of Inky Impression
//                    with the screen facing towards you
// _w = width = x-axis
// _d = depth = y-axis
// _h = height = z-axis
// _offset = distance from origin

// Fudge factors to extend cutouts slightly beyond surfaces
a_bit = 0.01;
a_bit_more = a_bit * 2;

// Make round things nicely rounded
$fn=50;

// Inky Impression dimensions
inky_board_w = 125;
inky_board_h = 100;
inky_board_d = 2.75;
inky_screen_w = 115;
inky_screen_h = 86;
inky_screen_offset_w = 5;
inky_screen_offset_h = 9;
inky_screen_cable_w = 23;
inky_screen_cable_h = 1;
inky_btn_a_offset_h = 81;
inky_btn_b_offset_h = 59.5;
inky_btn_c_offset_h = 38;
inky_btn_d_offset_h = 16.5;
inky_btn_offset_w = 0.5;
inky_btn_h = 7;
inky_btn_w = 3.5;
inky_btn_d = 3;
inky_btn_striker_w = 1;
inky_btn_striker_d = 1.5;
inky_btn_striker_h = 3;
inky_hdr_w = 52;
inky_hdr_h = 5;
inky_hdr_d = 5;
inky_hdr_offset_w = 43.5;
inky_hdr_offset_h = 76;
inky_conn_w = 26;
inky_conn_h = 8;
inky_conn_d = 3.5;
inky_conn_offset_w = 95.5;
inky_conn_offset_h = 3;
inky_mount_a_offset_w = 98.5;
inky_mount_a_offset_h = 29.5;
inky_mount_b_offset_w = 40.5;
inky_mount_b_offset_h = 78.5;
inky_mount_c_offset_w = 40.5;
inky_mount_c_offset_h = 29.5;
inky_mount_d_offset_w = 98.5;
inky_mount_d_offset_h = 78.5;
inky_mount_outer_r = 2.75;
inky_mount_d = 2.5;

// Raspberry Pi Zero dimensions
rpizero_w = 66;
rpizero_h = 30;
rpizero_d = 3;
rpizero_offset_w = 37;
rpizero_offset_h = 52;
rpizero_offset_d = 11.5;

// Frame dimensions
frame_thickness_front = 0.8;
frame_thickness_sides = 1.6;
frame_clearance_d = 0.5;
frame_clearance_w = 1;
frame_clearance_h = 0.5;
frame_border = 12;
frame_d = 20;
frame_w = inky_screen_w + (frame_border * 2);
frame_h = inky_screen_h + (frame_border * 2);
frame_offset_w = inky_screen_offset_w - frame_border;
frame_offset_h = inky_screen_offset_h - frame_border;
frame_offset_d = 0 - frame_clearance_d - frame_thickness_front;
frame_vent_hole_num = 20;
frame_vent_hole_r = 1.5;

// Backplane dimensions
backplane_clearance = 0.5; // cutout clearance around obstructions
backplane_mount_hole_r = 1.35;
backplane_mount_riser_d = 1.5;
backplane_mount_riser_r = backplane_mount_hole_r * 2;
backplane_offset_w = frame_offset_w + frame_thickness_sides;
backplane_offset_h = frame_offset_h + frame_thickness_sides;
backplane_offset_d = inky_board_d + inky_mount_d;
backplane_w = frame_w - frame_thickness_sides * 2;
backplane_h = frame_h - frame_thickness_sides * 2;
backplane_d = 1.6; // backplane thickness

// Button dimensions
button_w = inky_btn_offset_w - frame_offset_w - inky_btn_striker_w;
button_h = inky_btn_h;
button_d = inky_btn_d;
button_clearance = 0.2;
button_offset_w = inky_btn_offset_w - button_w - inky_btn_striker_w;
button_lug_d = backplane_d;
button_lug_h = inky_btn_striker_h;
button_lug_w = button_w - frame_thickness_sides - button_clearance;
button_lug_offset_w = frame_thickness_sides + button_clearance;
button_lug_offset_h = button_h / 2 - button_lug_h / 2;
button_lug_offset_d = button_d;

// io connector dimensions
io_w = 5.25;
io_h = 14;
io_d = 10;
io_offset_w = (inky_board_w / 2) - (io_w /2);
io_offset_h = backplane_offset_h + backplane_h - io_h;
io_offset_d = backplane_offset_d + backplane_d;
io_cutout_w = 0.35;
io_cutout_h = 1.5;
io_cutout_offset_h = 8.5;
io_support_w = 1.6;
io_support_h = io_h;
io_support_d = io_d - 1;
io_support_clearance = 0.01;
io_cover_clearance = 0.25;
io_cover_hole_pitch = 2.54;
io_cover_hole_r = 0.5;

// power connector dimensions
powerboard_w = 14;
powerboard_h = 15;
powerboard_d = 1.5;
powerboard_offset_w = (inky_board_w / 2) - (powerboard_w /2);
powerboard_offset_h = 1;
powerboard_socket_w = 7.5;
powerboard_socket_h = 5.75;
powerboard_socket_d = 2.5;
powerboard_socket_offset_h = -1;
powerboard_socket_clearance = 2;
powerboard_hole_r = 1.6;
powerboard_hole_offset_w = 2.5;
powerboard_hole_offset_h = 9;
backplane_powerboard_mount_a_offset_w = powerboard_offset_w + powerboard_hole_offset_w;
backplane_powerboard_mount_b_offset_w = powerboard_offset_w + powerboard_w - powerboard_hole_offset_w;
backplane_powerboard_mount_offset_h = powerboard_offset_h + powerboard_hole_offset_h;
backplane_powerboard_mount_hole_r = 1.25;
backplane_powerboard_mount_r = backplane_powerboard_mount_hole_r * 2;
backplane_powerboard_mount_d = 3;
powerboard_offset_d = backplane_offset_d + backplane_d + backplane_powerboard_mount_d;

// USB connector dimensions
usbboard_w = 17;
usbboard_h = 17;
usbboard_d = 1.5;
usbboard_offset_w = (inky_board_w / 4) - (usbboard_w /2);
usbboard_offset_h = 5;
usbboard_socket_w = 14.25;
usbboard_socket_h = 14;
usbboard_socket_d = 7;
usbboard_socket_offset_h = -5;
usbboard_socket_clearance = 2;
usbboard_stick_w = 14;
usbboard_stick_h = 19;
usbboard_stick_d = 4.6;
usbboard_stick_offset_h = -15;
usbboard_stick_offset_d = 1.5;
usbboard_hole_r = 1.5;
usbboard_hole_offset_w = 2.5;
usbboard_hole_offset_h = 11;
backplane_usbboard_mount_a_offset_w = usbboard_offset_w + usbboard_hole_offset_w;
backplane_usbboard_mount_b_offset_w = usbboard_offset_w + usbboard_w - usbboard_hole_offset_w;
backplane_usbboard_mount_offset_h = usbboard_offset_h + usbboard_hole_offset_h;
backplane_usbboard_mount_hole_r = 1.25;
backplane_usbboard_mount_r = backplane_usbboard_mount_hole_r * 2;
backplane_usbboard_mount_d = 3;
usbboard_offset_d = backplane_offset_d + backplane_d + backplane_usbboard_mount_d;

// rear panel dimensions
rearpanel_clearance = 0.2;
rearpanel_w = frame_w - frame_thickness_sides * 2 - rearpanel_clearance * 2;
rearpanel_h = frame_h - frame_thickness_sides * 2 - rearpanel_clearance * 2;
rearpanel_d = 1.6;
rearpanel_offset_w = frame_offset_w + frame_thickness_sides + rearpanel_clearance;
rearpanel_offset_h = frame_offset_h + frame_thickness_sides + rearpanel_clearance;
rearpanel_offset_d = frame_offset_d + frame_d - rearpanel_d;
rearpanel_mount_w = -frame_offset_w - frame_thickness_sides;
rearpanel_mount_d = rearpanel_offset_d - backplane_offset_d - backplane_d;
rearpanel_mount_h = 6;
rearpanel_mount_r = 3.5;
rearpanel_mount_insert_r = INSERT_DIAMETER / 2;
rearpanel_mount_bolt_r = BOLT_DIAMETER / 2;
rearpanel_mount_bolt_length = 6;
rearpanel_mount_bolt_clearance = 0.1;
rearpanel_key_slot_r = 2.5;
rearpanel_key_hole_r = 4.5;
rearpanel_key_slot_h = 7;
rearpanel_key_spacing_w = 100;

// stand dimensions
stand_angle = 20;
stand_offset_d = rearpanel_offset_d + rearpanel_d;
stand_base_clearance_h = 10;
stand_offset_h = frame_offset_h - stand_base_clearance_h;
stand_leg_w = 8;
stand_leg_h = inky_board_h * 2/3 + stand_base_clearance_h;
stand_leg_d = 40;
stand_leg_r = stand_leg_w / 2;
stand_peg_offset_h = inky_board_h / 2;
stand_peg_clearance = 0.1;
stand_peg_stem_r = rearpanel_key_slot_r - stand_peg_clearance;
stand_peg_stem_d = rearpanel_d + (stand_peg_clearance * 2);
stand_peg_flange_r = 4;
stand_peg_flange_d = rearpanel_d;

stand_leg1_offset_w = (inky_board_w / 2) - rearpanel_key_spacing_w / 2;
stand_leg2_offset_w = (inky_board_w / 2) + rearpanel_key_spacing_w / 2;
stand_crossbar_w = rearpanel_key_spacing_w + stand_leg_w;
stand_crossbar_d = stand_leg_w;
stand_crossbar_r = stand_leg_r;
stand_crossbar_offset_w = stand_leg1_offset_w - (stand_leg_w / 2) ;
stand_crossbar_offset_d = stand_offset_d + stand_leg_d - stand_crossbar_r;

// front cover dimensions
cover_thickness_front = 3;
cover_thickness_sides = 1.6;
cover_clearance = 0.1;
cover_spacer_d = 2;
cover_spacer_width = 2;
cover_overlap_d = 3;
cover_w = frame_w + (cover_thickness_sides * 2) + (cover_clearance * 2);
cover_h = frame_h + (cover_thickness_sides * 2) + (cover_clearance * 2);
cover_d = cover_thickness_front + cover_spacer_d + cover_overlap_d;
cover_offset_w = frame_offset_w - cover_thickness_sides - cover_clearance;
cover_offset_h = frame_offset_h - cover_thickness_sides - cover_clearance;
cover_offset_d = frame_offset_d - cover_thickness_front - cover_spacer_d;