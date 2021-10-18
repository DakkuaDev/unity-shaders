Shader "Custom/Normal"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Speed", Range(1, 5)) = 1
        _Amplitude ("Amplitude", Range(0, 1)) = 1 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Cull Off

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
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Speed;
            float _Amplitude;

            float4 direction (float4 vertexPos, float4 normalPos)
            {
                vertexPos += ((cos(_Time.y * _Speed) + 1) * _Amplitude) * normalPos;
                float4 vertex = UnityObjectToClipPos(vertexPos);
                return vertex;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = direction(v.vertex, v.normal);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {                
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
