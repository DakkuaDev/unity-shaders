Shader "Custom/Pattern"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Value1 ("Value 1", Range(0, 10)) = 1
        _Value2 ("Value 2", Range(0, 1)) = 0
        _Value3 ("Value 3", Range(1, 5)) = 2
        _Value4 ("Value 4", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Assets/01_ShaderLabCG/CGFiles/RotateCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 _Color;
            float _Value1;
            float _Value2;
            float _Value3;
            float _Value4;

            v2f vert (appdata v)
            {
                v2f o;   
                o.vertex = UnityObjectToClipPos(v.vertex);  
                o.uv = rotate(v.uv, _Value4);    // LLAMADA DESDE ROTATECG        
                //o.uv = v.uv;
                return o;
            }           

            // CUBE
            float shape (float x, float y)
            {
                float left =    step(0.1 * _Value1, x);
                float bottom =  step(0.1 * _Value1, y);
                float up =      step(0.1 * _Value1, 1 - y);
                float right =   step(0.1 * _Value1, 1 - x);

                return left * bottom * up * right;
            }

            fixed4 frag (v2f i) : SV_Target
            {    
                //float2 translation = float2(cos(_Time.y), sin(_Time.y));
                //i.uv += translation;

                i.uv = i.uv * _Value3 - _Value2;                 
                float cube = shape(frac(i.uv.x), frac(i.uv.y));
                //cube = abs(1 - cube);
                return cube * _Color;
            }
            ENDCG
        }
    }
}
