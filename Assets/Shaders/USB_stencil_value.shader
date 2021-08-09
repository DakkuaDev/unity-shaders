// Shader que actuará en función de la máscara para el cull buffer (Stencil Test)

Shader "MyShaders/USB_stencil_value"
{
    SubShader
    {
        Tags { "Queue" = "Geometry" }
        Stencil
        {
            Ref 1
            Comp NotEqual
            Pass Keep
        }
        
        Pass {}
    }
}
