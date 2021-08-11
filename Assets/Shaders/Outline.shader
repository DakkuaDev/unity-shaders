// Shader con efecto de outline cartoon

Shader "MyShaders/Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutColor ("Outline Color", Color) = (1,1,1,1) // Color del outline
        _OutMargin ("Outline Margin", Range(0.0, 0.5)) = 1 // Margen del outline
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        // Outline Pass
        Pass
        {
            // Tags
            Tags
            {
                "Qeue" = "Trasparent"
            }
            
            //Blending
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
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
            float4 _MainTex_ST;
            float4 _OutColor;
            float _OutMargin;

            /// Devuelve una nueva posición de los vértices multiplicada por la escala
            float4 outline(float4 vertexPos, float outValue)
            {
                float4x4 scale = float4x4
                (
                    1 + outValue,0,0,0,
                    0,1 + outValue,0,0,
                    0,0,1 + outValue,0,
                    0,0,0,1 + outValue
                );
                return mul(scale, vertexPos);
            }

            
            v2f vert (appdata v)
            {
                v2f o;
                float4 vertexPos = outline(v.vertex, _OutMargin);
                o.vertex = UnityObjectToClipPos(vertexPos);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                return float4 (_OutColor.rgba);
            }
            ENDCG
        }
        
        // Texture Pass
        Pass
        {
            // Tags
            Tags
            {
                "Qeue" = "Trasparent + 1"
            }
            
            // Blending
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
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                
                return col;
            }
            ENDCG
        }
    }
}
