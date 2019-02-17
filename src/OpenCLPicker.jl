module OpenCLPicker

export devicePicker,
       provideContext,
       @opencl

using OpenCL

macro opencl(expr)
    esc(
    quote
        if isdefined(Main, :OPENCL) && OPENCL
            $expr
        else
            :()
        end
    end
    )
end

function devicePicker()
    devices = cl.devices()
    show(stdout,"text/plain",cl.devices())
    println("\nPick a device [1-$(length(devices))]: ")
    return parse(Int32,readline())
end

function provideContext(DEVICE_ID::Integer=0)
    if DEVICE_ID==0
        DEVICE_ID = devicePicker()
    end
    cl_device = cl.devices()[DEVICE_ID]
    cl_ctx = cl.Context(cl_device)
    cl_queue = cl.CmdQueue(cl_ctx)
    return (cl_device, cl_ctx, cl_queue)
end

end
