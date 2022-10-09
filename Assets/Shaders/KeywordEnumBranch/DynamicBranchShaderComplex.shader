Shader "Dynamic Branch Shader Complex"
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

            #pragma dynamic_branch _ _VAR_TEST_AAA _VAR_TEST_BBB _VAR_TEST_CCC

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

            float4 frag (v2f i) : SV_Target
            {
                float3 outRGB = float3(0, 0, 0);
                for (uint x = 0; x < 1000; x++)
                {
                    if (_VAR_TEST_AAA)
                    {
                        float4 aaa = tex2D(_TexAAA, i.uvAAA) * float4(1, 0, 0, 1);
                        aaa.r -= pow(tan(exp(sin(log(cos(aaa.r))))), 0.25) * _CosTime.w * 0.25;
                        aaa.g += pow(tan(exp(sin(log(cos(aaa.g))))), 0.25) * _SinTime.z * 0.25;
                        aaa.b += pow(tan(exp(sin(log(cos(aaa.b))))), 0.25) * _SinTime.w * 0.25;
                        outRGB += aaa;
                    }
                    else if (_VAR_TEST_BBB)
                    {
                        float4 bbb = tex2D(_TexBBB, i.uvBBB) * float4(0, 1, 0, 1);
                        bbb.r += pow(tan(exp(sin(log(cos(bbb.r))))), 0.25) * _CosTime.w * 0.25;
                        bbb.g -= pow(tan(exp(sin(log(cos(bbb.g))))), 0.25) * _SinTime.z * 0.25;
                        bbb.b += pow(tan(exp(sin(log(cos(bbb.b))))), 0.25) * _SinTime.w * 0.25;
                        outRGB += bbb;
                    }
                    else if (_VAR_TEST_CCC)
                    {
                        float4 ccc = tex2D(_TexCCC, i.uvCCC) * float4(0, 0, 1, 1);
                        ccc.r += pow(tan(exp(sin(log(cos(ccc.r))))), 0.25) * _CosTime.w * 0.25;
                        ccc.g += pow(tan(exp(sin(log(cos(ccc.g))))), 0.25) * _SinTime.z * 0.25;
                        ccc.b -= pow(tan(exp(sin(log(cos(ccc.b))))), 0.25) * _SinTime.w * 0.25;
                        outRGB += ccc;
                    }
                }
                return float4(outRGB / 1000, 1);
            }

            ENDCG
        }
    }
}