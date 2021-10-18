Shader "Custom/ZTest"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags
		{
			"RenderType"="Transparent"
		}

        Pass
        {
            //ZTest LEqual    // DEFAULT
            //ZTest Greater
            ZTest Less
            //Cull Front

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

        // COLOR
        Pass
        {
            ZTest Greater
            CGPROGRAM
            #pragma vertex vertexShader
            #pragma fragment fragmentShader

            float4 _Color;

            struct vertexInput
            {
                float4 vertex : POSITION;
            };

            struct vertexOutput
            {
                float4 vertex : SV_POSITION;
            };

            vertexOutput vertexShader(vertexInput i)
            {
                vertexOutput o;
                o.vertex = UnityObjectToClipPos(i.vertex);
                return o;
            }

            float4 fragmentShader(vertexOutput o) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
