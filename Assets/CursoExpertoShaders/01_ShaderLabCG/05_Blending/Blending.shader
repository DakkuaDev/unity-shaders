Shader "Custom/Blending"
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
			"Queue"="Transparent"
		}   
		
		// BLEND PARA TODOS LOS PASES
		ZWrite Off
		//Blend SrcAlpha OneMinusSrcAlpha	// TRADITIONAL TRANSPARENCY
		Blend One OneMinusSrcAlpha		// PREMULTIPLIED TRANSPARENCY
		//Blend One One						// ADD
		//Blend OneMinusDstColor One		// SOFT ADD
		//Blend DstColor Zero				// MULTIPLY
		//Blend DstColor SrcColor			// 2X MULTIPLY
		//Blend SrcColor One				// OVERLAY
		//Blend OneMinusSrcColor One		// SOFT LIGHT
		//Blend Zero OneMinusSrcColor			// SUBTRACT

		//BlendOp Add							// DEFAULT VALUE
		BlendOp Sub
		//BlendOp Max
		//BlendOp Min
		//BlendOp RevSub

        Pass
        {
			// BLEND PARA ESTE PASE ESPECIFICO

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
			float4 _Color;

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
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                return col;
            }
            ENDCG
        }
    }
}
