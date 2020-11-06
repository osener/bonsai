(** A snapshot represents the state of a component at an instant in time. *)

open! Core_kernel
open! Import

type ('model, 'action, 'result) t

(** Applies the provided action to the model in force at the time that the snapshot was
    created.

    The application of the action is allowed to engage in side-effecting computations,
    including calling the [schedule_event] function to request that further actions be
    enqueued to be applied to the model. *)
val apply_action
  :  ('model, 'action, _) t
  -> (schedule_event:(Event.t -> unit) -> 'action -> 'model) Incr.t

(** [after_display] contains a function that should be called after every
    render.  What a "render" means for a given Bonsai backend isn't well
    defined. *)
val after_display : _ t -> (schedule_event:(Event.t -> unit) -> unit) option Incr.t

(** The result of a component is the primary value computed by the component in
    question. At the top level of a UI, this is generally a representation of the view,
    but it's often useful to compute other kinds of results in inner components. *)
val result : (_, _, 'result) t -> 'result Incr.t

(** Creates a new snapshot. Note that the [apply_action] provided here should apply the
    action in question to the model in force at the time [create] is called. *)
val create
  :  apply_action:(schedule_event:(Event.t -> unit) -> 'action -> 'model) Incr.t
  -> after_display:(schedule_event:(Event.t -> unit) -> unit) option Incr.t
  -> result:'result Incr.t
  -> ('model, 'action, 'result) t
