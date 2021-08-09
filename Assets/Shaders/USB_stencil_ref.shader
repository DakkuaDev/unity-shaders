// Shader a modo de "máscara" para el cull buffer (Stencil Test)

Shader "MyShaders/USB_stencil_ref"
{
    SubShader
    {
        Tags { "Queue" = "Geometry -1" }
        ZWrite Off
        ColorMask 0

        Stencil
        {
            Ref 1
            Comp Always
            Pass Replace
        }
        
        Pass{}
    }
}

