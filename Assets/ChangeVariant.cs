using System.Collections;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public class ChangeVariant : MonoBehaviour
{
    public MeshRenderer mr;
    public Text text;
    public float waitTime = 5.0f;

    private Material mat;
    private string sceneName;
    private string matName;
    private string graphicsAPIName;
    private StringBuilder sb;

    private const string TextScene       = "scene = ";
    private const string TextMat         = "mat = ";
    private const string TextGraphicsAPI = "GraphicsAPI = ";
    private const string VariantAAA      = "_VAR_TEST_AAA";
    private const string VariantBBB      = "_VAR_TEST_BBB";
    private const string VariantCCC      = "_VAR_TEST_CCC";
    private const string UseTexAAA       = "_USE_TEXAAA_ON";
    private const string UseTexBBB       = "_USE_TEXBBB_ON";
    private const string UseTexCCC       = "_USE_TEXCCC_ON";

    private static readonly int VarTestPropID   = Shader.PropertyToID("_Var_Test");
    private static readonly int UseTexAAAPropID = Shader.PropertyToID("_Use_TexAAA");
    private static readonly int UseTexBBBPropID = Shader.PropertyToID("_Use_TexBBB");
    private static readonly int UseTexCCCPropID = Shader.PropertyToID("_Use_TexCCC");
    private static readonly Color TextColorAAA  = Color.red;
    private static readonly Color TextColorBBB  = Color.green;
    private static readonly Color TextColorCCC  = Color.blue;

    void Start()
    {
        this.sceneName = UnityEngine.SceneManagement.SceneManager.GetActiveScene().name;
        this.graphicsAPIName = UnityEngine.SystemInfo.graphicsDeviceType.ToString();
        this.sb = new StringBuilder();
        if (this.mr != null)
        {
            this.mat = this.mr.sharedMaterial;
            this.matName = this.mat.name;
        }
        if (this.mat != null)
        {
            StartCoroutine("Change");
        }
    }

    IEnumerator Change()
    {
        while (true)
        {
            this.mat.EnableKeyword(VariantAAA);
            this.mat.DisableKeyword(VariantBBB);
            this.mat.DisableKeyword(VariantCCC);

            if (this.mat.HasProperty(VarTestPropID))
            {
                this.mat.SetInt(VarTestPropID, 1);
            }

            if (this.mat.HasProperty(UseTexAAAPropID))
            {
                this.mat.SetInt(UseTexAAAPropID, 1);
            }
            if (this.mat.HasProperty(UseTexBBBPropID))
            {
                this.mat.SetInt(UseTexBBBPropID, 0);
            }
            if (this.mat.HasProperty(UseTexCCCPropID))
            {
                this.mat.SetInt(UseTexCCCPropID, 0);
            }

            this.sb.Clear();
            this.sb.AppendLine(VariantAAA)
                .Append(TextScene).AppendLine(this.sceneName)
                .Append(TextMat).AppendLine(this.matName)
                .Append(TextGraphicsAPI).AppendLine(this.graphicsAPIName);
            this.text.text = this.sb.ToString();
            this.text.color = TextColorAAA;
            yield return new WaitForSeconds(this.waitTime);

            this.mat.DisableKeyword(VariantAAA);
            this.mat.EnableKeyword(VariantBBB);
            this.mat.DisableKeyword(VariantCCC);

            if (this.mat.HasProperty(VarTestPropID))
            {
                this.mat.SetInt(VarTestPropID, 2);
            }

            if (this.mat.HasProperty(UseTexAAAPropID))
            {
                this.mat.SetInt(UseTexAAAPropID, 0);
            }
            if (this.mat.HasProperty(UseTexBBBPropID))
            {
                this.mat.SetInt(UseTexBBBPropID, 1);
            }
            if (this.mat.HasProperty(UseTexCCCPropID))
            {
                this.mat.SetInt(UseTexCCCPropID, 0);
            }

            this.sb.Clear();
            this.sb.AppendLine(VariantBBB)
                .Append(TextScene).AppendLine(this.sceneName)
                .Append(TextMat).AppendLine(this.matName)
                .Append(TextGraphicsAPI).AppendLine(this.graphicsAPIName);
            this.text.text = this.sb.ToString();
            this.text.color = TextColorBBB;
            yield return new WaitForSeconds(this.waitTime);

            this.mat.DisableKeyword(VariantAAA);
            this.mat.DisableKeyword(VariantBBB);
            this.mat.EnableKeyword(VariantCCC);

            if (this.mat.HasProperty(VarTestPropID))
            {
                this.mat.SetInt(VarTestPropID, 3);
            }

            if (this.mat.HasProperty(UseTexAAAPropID))
            {
                this.mat.SetInt(UseTexAAAPropID, 0);
            }
            if (this.mat.HasProperty(UseTexBBBPropID))
            {
                this.mat.SetInt(UseTexBBBPropID, 0);
            }
            if (this.mat.HasProperty(UseTexCCCPropID))
            {
                this.mat.SetInt(UseTexCCCPropID, 1);
            }

            this.sb.Clear();
            this.sb.AppendLine(VariantCCC)
                .Append(TextScene).AppendLine(this.sceneName)
                .Append(TextMat).AppendLine(this.matName)
                .Append(TextGraphicsAPI).AppendLine(this.graphicsAPIName);
            this.text.text = this.sb.ToString();
            this.text.color = TextColorCCC;
            yield return new WaitForSeconds(this.waitTime);
        }
    }
}