Shader "Jettelly/Dissolve"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DisTex ("Dissolve Texture", 2D) = "white" {}
        [Space(10)]
        _DisColor ("Dissolve Color", Color) = (1, 1, 1, 1)
        _DisSmooth ("Dissolve Smooth", Range(0.0, 0.2)) = 0
        _DisThreshold ("Dissolve Threshold", Range(-0.2, 1.2)) = 1 
    }
    SubShader
    {
        Tags 
        { 
            "Queue"="Transparent" 
        }        
        // COLOR PASS ------------------------------------
        Pass
        {
            Blend SrcAlpha One

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
            sampler2D _DisTex;
            float4 _MainTex_ST;
            float4 _DisColor;
            float _DisSmooth;
            float _DisThreshold;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {         
                float dissolve = tex2D(_DisTex, i.uv).r;
                //_DisThreshold += sin(_Time.y) - 0.2;
                float smooth = smoothstep(_DisThreshold + 0.1, _DisThreshold - _DisSmooth, dissolve);

                fixed4 col = tex2D(_MainTex, i.uv);
                col.a *= smooth;
                return float4(_DisColor.rgb, col.a);
            }
            ENDCG
        }
        // TEXTURE PASS ------------------------------------
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

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
            sampler2D _DisTex;
            float4 _MainTex_ST;
            float _DisSmooth;
            float _DisThreshold;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {         
                float dissolve = tex2D(_DisTex, i.uv).r;
                //_DisThreshold += sin(_Time.y) - 0.2;
                float smooth = smoothstep(_DisThreshold, _DisThreshold - _DisSmooth, dissolve);

                fixed4 col = tex2D(_MainTex, i.uv);
                col.a *= smooth;
                return col;
            }
            ENDCG
        }
    }
}
