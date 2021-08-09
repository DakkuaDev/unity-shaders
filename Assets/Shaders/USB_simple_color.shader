// Shader que ejemplifica la lógica básica del ShaderLab de Unity (Propiedades, SubShader, Tags...)

Shader "MyShaders/USB_simple_color"
{
    // ---------------------- Propiedades: Se exponen al editor ---------------------------//
    // Sintaxis: Nombre_variable(Nombre_inspector, tipo_de_dato) = valor
    Properties
    {
        // Propiedades de textura
        _MainTex ("Texture", 2D) = "white" {} // Textura
        _Reflection ("Reflection", Cube) = "black" {} // Reflexión
        _3DTexture ("3D Texture", 3D) = "white" {} // Textura 3D
        [Space(10)]
        
        // Propiedades de iluminación
        _Specular ("Specular", Range(0.0, 1.1)) = 0.3 // Luz especular
        _Factor ("Color Factor", Float) = 0.3 // Factor de color
        _Cid ("Color id", Int) = 2 // id color
        [Space(10)]

        // Propiedades para Colores y Vectores
        _Color ("Tint", Color) = (1, 1, 1, 1) // Color
        _VPos ("Vertex Position", Vector) = (0, 0, 0, 1) // Posición de vértices
        [Space(10)]
   
        // Propiedades Drawer (tipos de datos especiales)
        [Toggle] _Toggle ("Toggle", Float) = 0 // booleano
        
        [KeywordEnum(Off, Red, Blue)] 
        _Options ("Color Options", Float) = 0 // opciones
        
        [Enum(Off, 0, Front, 1, Back, 2)] 
        _Face ("Face Culling", Float) = 0 // enumerador
        
        [PowerSlider(3.0)] 
            _Brightness ("Brightness", Range (0.01, 1)) = 0.08 // slider

        [IntRange] 
            _Samples ("Samples", Range (0, 255)) = 100 // rango de números
        
        // Propiedades de Tags
        [Enum(UnityEngine.Rendering.BlendMode)] 
            _SrcBlend ("SrcFactor", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] 
            _DstBlend ("DstFactor", Float) = 1
    }
    // ---------------------- Subshader: Cada programa de shader (puede haber varios) ---------------------------//
    SubShader
    {
        // ---------------------- Tags: Asociaciones entre conjuntos de shaders ---------------------------//
        
        /// 1. Z - Buffer (Orden de dibujado en la CPU, de más lejado a más cercano
        Tags {"Queue" = "Transparent"} 

         // from 0 to 1499, default value 1000 
        //Tags {"Queue" = "Background"} 
        // from 1500 to 2399, default value 2000 
        //Tags {"Queue" = "Geometry"} 
        // from 2400 to 2699, default value 2450 
        //Tags {"Queue" = "AlphaTest"} 
        // from 2700 to 3599, default value 3000 
        //Tags {"Queue" = "Transparent"} 
        // from 3600 to 5000, default value 4000 
        //Tags {"Queue" = "Overlay"}
        
        /// 2. Tipo de Render (Opaco, Trasparente...)
        Tags { "RenderType" = "Transparent" } 
        
        // ----------- Blending: Operación de juntar 2 colores de pixel en uno solo. Se realiza después del fragment shader ------------//
        
        Blend [_SrcBlend] [_DstBlend]
        
        //Blend SrcAlpha OneMinusSrcAlpha     // common transparent blending 
        //Blend One One                       // additive blending color 
        //Blend OneMinusDstColor One          // mild additive blending color 
        //Blend DstColor Zero                 // multiplicative blending color 
        //Blend DstColor SrcColor             // multiplicative blending x2 
        //Blend SrcColor One                  // blending overlay 
        //Blend OneMinusSrcColor One          // soft light blending 
        //Blend Zero OneMinusSrcColor         // negative color blending
        
         // ----------------- AlphaToMask: Agrega el canal de Alpha duro (0-1) a las operaciones de Blending -----------------------//
        
         AlphaToMask On 
        
        // ------------------- ColorMask: Deja solo aquellos canales de color que especifiquemos al shader -------------------------//
        
        ColorMask RGBA
        
        //ColorMask R         // our object will look red.
        //ColorMask G         // our object will look green.
        //ColorMask B         // our object will look blue.
        //ColorMask A         // our object will be affected by transparency. 
        //ColorMask RG        // we can use two channel mixing.
        
        // ------------------- Culling: Caras visibles. Back: externas, Front: Internas, Off: ambas --------------------------------//
        
        Cull [_Face]
        
        // ------------------ Z-Writing: dibujado o no respecto a la profundidad objeto - cámara -----------------------------------//
        
        ZWrite Off
        
        // Se suele usar 'off' cuando existen trasparencias, ya que el render no sabe distinguir que caras van primero
        
        // ------------------ Z-Test: Comparaciones del Z-Buffer para saber que objetos se deben dibujar ---------------------------//
        
        ZTest LEqual
        
        //ZTest Less (<)         // Dibuja los objetos por delante.
        //ZTest Greater (>)      // Dibuja al objeto que está detrás.
        //ZTest LEqual (≤)       // Valor por defecto. Dibuja el objeto que está delante o a la misma distancia.
        //ZTest GEqual (≥)       // Dibuja el objeto que está detrás o a la misma distancia. 
        //ZTest Equal (==)       // Dibuja a los objetos que están a la misma distancia.
        //ZTest NotEqual (!=)    // Dibuja al objeto que no está a la misma distancia.
        //ZTest Always           // Dibuja todos los píxeles independientemente de la distancia de un objeto respecto a la cámara.
        
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            // Toggle condition 
            #pragma shader_feature _ENABLE_ON
            #pragma multi_compile _OPTIONS_OFF _OPTIONS_RED  _OPTIONS_BLUE

             // generate connection variables 
            float _Brightness;
            int _Samples;
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
