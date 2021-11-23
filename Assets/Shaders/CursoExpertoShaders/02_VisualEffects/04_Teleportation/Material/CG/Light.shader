Shader "Jettelly/Light"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Intencity ("Intencity", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags 
        { 
            "Queue"="Transparent" 
        }
        
        Blend SrcAlpha One

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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
            float _Intencity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {               
                float gradient = abs(1 - i.uv.y);
                return float4(_Color.rgb, gradient * _Intencity);
            }
            ENDCG
        }
    }
}
