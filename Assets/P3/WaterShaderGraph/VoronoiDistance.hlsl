#ifndef VORONOI_DISTANCE_INCLUDED
#define VORONOI_DISTANCE_INCLUDED

void VoronoiDistance_float(float2 uv, float phase, out float res)
{
    float2 n = floor(uv);
    float2 f = frac(uv);

    float2 mg, mr;
    float md = 8.0;

    for (int j = -1; j <= 1; j++)
    {
        for (int i = -1; i <= 1; i++)
        {
            float2 g = float2(i, j);
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            float2 uvr = frac(sin(mul(g + n, m)) * 46839.32);
            float2 o = float2(sin(uvr.y * phase) * 0.5 + 0.5, cos(uvr.x * phase) * 0.5 + 0.5);
            float2 r = g + o - f;
            float d = dot(r, r);

            if (d < md)
            {
                md = d;
                mr = r;
                mg = g;
            }
        }
    }

    md = 8.0;

    for (int j = -2; j <= 2; j++)
    {
        for (int i = -2; i <= 2; i++)
        {
            float2 g = mg + float2(i, j);
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            float2 uvr = frac(sin(mul(g + n, m)) * 46839.32);
            float2 o = float2(sin(uvr.y * phase) * 0.5 + 0.5, cos(uvr.x * phase) * 0.5 + 0.5);
            float2 r = g + o - f;

            if (dot(mr - r, mr - r) > 0.0001)
            {
                md = min(md, dot(0.5 * (mr + r), normalize(r - mr)));
            }
        }
    }

    res = md;
}

#endif