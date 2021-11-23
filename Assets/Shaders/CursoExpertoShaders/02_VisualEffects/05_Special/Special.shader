Shader "Jettelly/Special"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _PattTex ("Pattern Texture", 2D) = "white" {}
        _RampTex ("Ramp Texture", 2D) = "white" {}
        [Space(10)]
        _RampSpeed ("Ramp Speed", Range(1, 10)) = 10
        _RampSaturation ("Ramp Saturation", Range(1, 4)) = 3
        [Space(10)]
        _RimColor ("Rim Color", Color) = (1, 1, 1, 1)
        _RimEffect ("Rim Effect", Range(0, 1)) = 1
    }
    SubShader
    {    
        // TEXTURE PASS ---------------------------- 1
        Pass
        {
            Cull Front

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

            sampler2D _MainTex;
            sampler2D _PattTex;
            sampler2D _RampTex;
            float4 _MainTex_ST;

            float _RampSpeed;
            float _RampSaturation;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {                
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed patt = tex2D(_PattTex, i.uv).r;
                fixed4 ramp = tex2D(_RampTex, fixed2(patt + _Time.x * _RampSpeed, 1)) * _RampSaturation;

                float4 mixed = lerp(ramp, col, 0.85);
                return mixed;
            }
            ENDCG
        }

        // RIM PASS ---------------------------- 2        
        Pass
        {
            Tags
            {
                "Queue"="Transparent"
            }
            
            Blend One One

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float3 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            float4 _RimColor;
            float _RimEffect;

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = normalize(mul(unity_ObjectToWorld, v.normal));
                o.uv = normalize(_WorldSpaceCameraPos - mul(unity_ObjectToWorld, v.vertex.xyz));

                return o;
            }

            float rimEffect(float3 uv, float3 normal)
            {
                float rim = 1 - abs(dot(uv, normal)) * _RimEffect;
                return rim;
            }

            fixed4 frag (v2f i) : SV_Target
            {       
                fixed rimCol = rimEffect(i.uv, i.normal);        
                return _RimColor * rimCol * rimCol;
            }
            ENDCG
        }        
    }
}
