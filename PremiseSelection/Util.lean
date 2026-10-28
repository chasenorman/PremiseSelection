module

import Std.Sync.Channel
import Lean.Meta.Basic
public meta import Std.Sync.Channel
public meta import Lean.Server.Requests
public meta import Lean.Server.Rpc.RequestHandling

open Lean Meta Expr Elab Term Server Tactic Core RequestM IO

public section

namespace Canonical2

abbrev Pipe := Std.Channel.Sync Json
meta instance : TypeName Pipe := unsafe (.mk _ ``Pipe)

def Pipe.log (pipe : Pipe) (key value : String) : IO Unit :=
  pipe.send (Json.mkObj [(key, Json.str value)])

@[server_rpc_method]
meta def recv (pipe : WithRpcRef Pipe) : RequestM (RequestTask Json) := asTask pipe.val.recv

structure CancelableTask (α : Type) where
  task : Task α
  cancelPost : IO Unit := pure ()

abbrev MetaTask α := CancelableTask (Except IO.Error (α × Core.State × Meta.State))

end Canonical2

def Lean.Meta.MetaM.toTask {α} (x : MetaM α) (cancel : IO Unit := pure ()) : MetaM (Canonical2.MetaTask α) :=
  fun metaCtx metaState coreCtx coreState => do
    return ⟨← IO.asTask do MetaM.toIO x coreCtx (← coreState.get) metaCtx (← metaState.get), cancel⟩
