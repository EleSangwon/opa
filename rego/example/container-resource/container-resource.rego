package kubernetes.containerResourceLimits

canonify_cpu(orig) := new {
  is_number(orig)
  new := orig * 1000
}
canonify_mem(orig) := new {
  is_number(orig)
  new := orig * 1000
}
missing(obj, field) := true {
  not obj[field]
}

missing(obj, field) := true {
  obj[field] == ""
}
# check1. cpu is number
violation[{"msg": msg}] {
  container := input.request.object.spec.containers[_]
  cpu_orig := container.resources.limits.cpu
  not canonify_cpu(cpu_orig) # if cpu is string and then print
  msg := sprintf("container <%v> cpu limit <%v> could not be parsed", [container.name, cpu_orig])
}

# check2. memory is number
violation[{"msg": msg}] {
  container := input.request.object.spec.containers[_]
  mem_orig := container.resources.limits.memory
  not canonify_mem(mem_orig) # if memory is string and then print
  msg := sprintf("container <%v> memory limit <%v> could not be parsed", [container.name, mem_orig])
}

# check3. if not exist resource limits
violation[{"CHECK-3": msg}] {
  container := input.request.object.spec.containers[_]
  not container.resources.limits
  msg := sprintf("No limit resources container <%v>, container image : <%v>", [container.name,container.image])
}

# check4. if not exist resource requests
violation[{"CHECK-4": msg}] {
  container := input.request.object.spec.containers[_]
  not container.resources.requests
  msg := sprintf("No Request resource in container <%v>, container image : <%v>", [container.name,container.image])
}

# check5. if resouce cpu limit is empty
violation[{"CHECK-5": msg}] {
  container := input.request.object.spec.containers[_]
  missing(container.resources.limits,"cpu")
  msg := sprintf("No CPU Limit resource in container name :<%v>, container image : <%v>", [container.name,container.image])
}

# check6. if resouce memory limit is empty
violation[{"CHECK-6": msg}] {
  container := input.request.object.spec.containers[_]
  missing(container.resources.limits,"memory")
  msg := sprintf("No CPU Limit resource in container name :<%v>, container image : <%v>", [container.name,container.image])
}

# violation[{"msg": msg, "msg2":msg2}] {
#   container := input.request.object.spec.containers[_]
#   not container.resources.limits
#   msg := sprintf("container <%v> has no resource limits", [container.name])
#   msg2 := sprintf("container <%v> has no resource limits", [container.name])
# }