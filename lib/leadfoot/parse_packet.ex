defmodule Leadfoot.ParsePacket do
  @moduledoc """


  racing: 0 if not racing
  timestamp: number that never decreases. seems to increase at 60hz
  max_rpm: could be red line, fuel cut off or something else
  idle_rpm: rpm when the engine is idling
  current_rpm: current engine rpm
  acceleration: acceleration is in m/s^2
  velocity: velocity is in m/s
  angular_velocity: angular_velocity,
  yaw_pitch_roll: yaw_pitch_roll,
  norm_suspension: normalized suspension travel, from 0 to 1
  tire_slip_ratio: tire_slip_ratio,
  wheel_rotation: wheel rotation is in rad/sec
  on_rumble: on_rumble,
  in_puddle: in_puddle,
  surface_rumble: surface_rumble,
  tire_slip_angle: tire_slip_angle,
  tire_comb_slip: tire_comb_slip,
  suspension_travel: suspension travel is in meters
  car_id: unique id for car
  car_class: 0 for D up to 6 for X
  car_performance: PI points
  drivetrain: 0 for FWD, 1 for RWD, 2 for AWD
  num_cylinders: num_cylinders,
  car_category: car_category,
  unknown1: 4 unknown bytes. seems to change when crashing
  unknown2: 4 unknown bytes. seems to change when crashing
  world_position: world_position,
  speed: speed is in m/s
  power: power is in watts
  torque: torque is in n/m
  tire_temp: tire temp is in f. Note: not metric.
  boost: boost,
  fuel: fuel,
  distance: distance,
  best_lap_time: best_lap_time,
  last_lap_time: last_lap_time,
  current_lap_time: current_lap_time,
  current_race_time: current_race_time,
  lap: lap,
  race_position: race_position,
  accelerator: accelerator,
  brake: brake,
  clutch: clutch,
  handbrake: handbrake,
  gear: 11 for neutral, 0 for reverse
  steer: steer,
  driving_line: driving_line,
  ai_brake: ai_brake
  """

  def parse_triple(<<x::little-float-32, y::little-float-32, z::little-float-32>>) do
    %{x: x, y: y, z: z}
  end

  def parse_corners(<<fl::little-float-32, fr::little-float-32, rl::little-float-32, rr::little-float-32>>) do
    %{front: %{left: fl, right: fr}, rear: %{left: rl, right: rr}}
  end

  def parse_packet(
        <<racing::little-32, timestamp::little-32, max_rpm::little-float-32, idle_rpm::little-float-32,
          current_rpm::little-float-32, acceleration::bytes-12, velocity::bytes-12, angular_velocity::bytes-12,
          yaw_pitch_roll::bytes-12, norm_suspension::bytes-16, tire_slip_ratio::bytes-16, wheel_rotation::bytes-16,
          on_rumble::bytes-16, in_puddle::bytes-16, surface_rumble::bytes-16, tire_slip_angle::bytes-16,
          tire_comb_slip::bytes-16, suspension_travel::bytes-16, car_id::little-32, car_class::little-32,
          car_performance::little-32, drivetrain::little-32, num_cylinders::little-32, car_category::little-32,
          unknown1::bytes-4, unknown2::bytes-4, world_position::bytes-12, speed::little-float-32, power::little-float-32,
          torque::little-float-32, tire_temp::bytes-16, boost::little-float-32, fuel::little-float-32,
          distance::little-float-32, best_lap_time::little-float-32, last_lap_time::little-float-32,
          current_lap_time::little-float-32, current_race_time::little-float-32, lap::little-16, race_position::little-8,
          accelerator::little-8, brake::little-8, clutch::little-8, handbrake::little-8, gear::little-8,
          steer::little-signed-8, driving_line::little-8, ai_brake::little-8, rest::bytes>>
      ) do
    acceleration = parse_triple(acceleration)
    velocity = parse_triple(velocity)
    angular_velocity = parse_triple(angular_velocity)
    yaw_pitch_roll = parse_triple(yaw_pitch_roll)
    norm_suspension = parse_corners(norm_suspension)
    tire_slip_ratio = parse_corners(tire_slip_ratio)
    wheel_rotation = parse_corners(wheel_rotation)
    on_rumble = parse_corners(on_rumble)
    in_puddle = parse_corners(in_puddle)
    surface_rumble = parse_corners(surface_rumble)
    tire_slip_angle = parse_corners(tire_slip_angle)
    tire_comb_slip = parse_corners(tire_comb_slip)
    suspension_travel = parse_corners(suspension_travel)
    world_position = parse_triple(world_position)
    tire_temp = parse_corners(tire_temp)

    %{
      racing: racing,
      timestamp: timestamp,
      max_rpm: max_rpm,
      idle_rpm: idle_rpm,
      current_rpm: current_rpm,
      acceleration: acceleration,
      velocity: velocity,
      angular_velocity: angular_velocity,
      yaw_pitch_roll: yaw_pitch_roll,
      norm_suspension: norm_suspension,
      tire_slip_ratio: tire_slip_ratio,
      wheel_rotation: wheel_rotation,
      on_rumble: on_rumble,
      in_puddle: in_puddle,
      surface_rumble: surface_rumble,
      tire_slip_angle: tire_slip_angle,
      tire_comb_slip: tire_comb_slip,
      suspension_travel: suspension_travel,
      car_id: car_id,
      car_class: car_class,
      car_performance: car_performance,
      drivetrain: drivetrain,
      num_cylinders: num_cylinders,
      car_category: car_category,
      unknown1: unknown1,
      unknown2: unknown2,
      world_position: world_position,
      speed: speed,
      power: power,
      torque: torque,
      tire_temp: tire_temp,
      boost: boost,
      fuel: fuel,
      distance: distance,
      best_lap_time: best_lap_time,
      last_lap_time: last_lap_time,
      current_lap_time: current_lap_time,
      current_race_time: current_race_time,
      lap: lap,
      race_position: race_position,
      accelerator: accelerator,
      brake: brake,
      clutch: clutch,
      handbrake: handbrake,
      gear: gear,
      steer: steer,
      driving_line: driving_line,
      ai_brake: ai_brake,
      unknown3: rest
    }
  end
end
