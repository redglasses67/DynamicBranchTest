Shader "Multi Compile Shader Simple"
{
    Properties
    {
        _TexAAA ("Tex AAA", 2D) = "white" {}
        _TexBBB ("Tex BBB", 2D) = "white" {}
        _TexCCC ("Tex CCC", 2D) = "white" {}
        [KeywordEnum(None, AAA, BBB, CCC)] _Var_Test ("Variant Test", Float) = 1
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _ _VAR_TEST_AAA _VAR_TEST_BBB _VAR_TEST_CCC

            #include "UnityCG.cginc"

            sampler2D _TexAAA, _TexBBB, _TexCCC;
            float4 _TexAAA_ST, _TexBBB_ST, _TexCCC_ST;

            struct appdata
            {
                float4 position : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uvAAA    : TEXCOORD0;
                float2 uvBBB    : TEXCOORD1;
                float2 uvCCC    : TEXCOORD2;
            };

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                o.position = UnityObjectToClipPos(v.position);

                if (_VAR_TEST_AAA)
                {
                    o.uvAAA = TRANSFORM_TEX(v.texcoord, _TexAAA);
                }
                else if (_VAR_TEST_BBB)
                {
                    o.uvBBB = TRANSFORM_TEX(v.texcoord, _TexBBB);
                }
                else if (_VAR_TEST_CCC)
                {
                    o.uvCCC = TRANSFORM_TEX(v.texcoord, _TexCCC);
                }
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                if (_VAR_TEST_AAA)
                {
                    return tex2D(_TexAAA, i.uvAAA) * half4(1, 0, 0, 1);
                }
                else if (_VAR_TEST_BBB)
                {
                    return tex2D(_TexBBB, i.uvBBB) * half4(0, 1, 0, 1);
                }
                else if (_VAR_TEST_CCC)
                {
                    return tex2D(_TexCCC, i.uvCCC) * half4(0, 0, 1, 1);
                }
                else
                {
                    return half4(1, 1, 1, 1);
                }
            }

            ENDCG
        }
    }
}