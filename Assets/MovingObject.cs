using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovingObject : MonoBehaviour
{
    public Transform centerPoint; // Dairesel hareketin merkezi
    public float radius = 2.0f; // Dairesel hareket yarıçapı
    public float horizontalSpeed = 1.0f; // Sağ-sol hareket hızı
    public float verticalSpeed = 1.0f; // Yukarı-aşağı hareket hızı
    public float sensitivity = 1.0f; // Hareket hassasiyeti
    public float minY = 0.0f; // Y ekseninde minimum pozisyon
    public float maxY = 25.0f; // Y ekseninde maximum pozisyon

    private Vector2 touchStartPos;
    private Vector2 touchEndPos;
    private float horizontalAngle = 0.0f;
    private float verticalAngle = 0.0f;

    void Update()
    {
        if (Input.touchCount > 0)
        {
            Touch touch = Input.GetTouch(0);

            if (touch.phase == TouchPhase.Began)
            {
                touchStartPos = touch.position;
            }
            else if (touch.phase == TouchPhase.Moved)
            {
                touchEndPos = touch.position;
                Vector2 delta = touchEndPos - touchStartPos;

                float horizontalMovement = (delta.x * sensitivity);
                float verticalMovement = delta.y * sensitivity;

                horizontalAngle -= horizontalMovement * horizontalSpeed * Time.deltaTime;
                verticalAngle += verticalMovement * verticalSpeed * Time.deltaTime;

                float x = centerPoint.position.x + Mathf.Cos(horizontalAngle) * radius;
                float z = centerPoint.position.z + Mathf.Sin(horizontalAngle) * radius;
                float y = Mathf.Clamp(centerPoint.position.y + verticalAngle * radius, minY, maxY);

                transform.position = new Vector3(x, y, z);

                touchStartPos = touchEndPos;
            }
        }
    }
}
